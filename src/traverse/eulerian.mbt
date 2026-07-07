///|
/// Eulerian trail/circuit for **directed** graphs using Hierholzer's algorithm.
///
/// Returns `Some(path)` with node ids (each edge traversed exactly once), or
/// `None` when no Eulerian trail exists.
///
/// # Correctness notes (isolated vertices & atypical structures)
/// - Isolated vertices (degree 0) never participate in the trail and never
///   invalidate an otherwise valid trail.
/// - When the degree condition yields a circuit (all `out - in == 0`), the
///   start vertex is chosen as the **first vertex that actually owns an edge**,
///   so an isolated vertex sitting at index 0 cannot poison the search.
/// - A trail only exists when **all** edges lie in one weakly connected
///   component; this is enforced by checking that the produced path covers
///   exactly `total_edges + 1` vertices. Disconnected edge sets return `None`.
///
/// # Conditions
/// - Circuit: every vertex has `out_deg == in_deg` (within one SCC).
/// - Trail: exactly one vertex with `out - in == 1` (start) and one with
///   `in - out == 1` (end); all others balanced.
pub fn eulerian_trail(g : @graph.Graph[Int, Int]) -> Array[Int]? {
  let n = g.node_count()
  if n == 0 {
    return Some([])
  }

  let indeg : Array[Int] = Array::make(n, 0)
  let outdeg : Array[Int] = Array::make(n, 0)
  let mut total_edges = 0

  // Count in/out degrees (parallel edges and self-loops are accounted for).
  for v = 0; v < n; v = v + 1 {
    let oe = g.out_edges(v)
    outdeg[v] = oe.length()
    total_edges = total_edges + oe.length()
    for j = 0; j < oe.length(); j = j + 1 {
      let e = g.get_edge(oe[j])
      indeg[e.to] = indeg[e.to] + 1
    }
  }

  // No edges at all: trivial empty trail (isolated vertices are irrelevant).
  if total_edges == 0 {
    return Some([])
  }

  // Validate degree balance and locate the trail start.
  let mut start = -1
  let mut start_extra = 0
  let mut end_extra = 0
  for i = 0; i < n; i = i + 1 {
    let diff = outdeg[i] - indeg[i]
    if diff == 1 {
      start = i
      start_extra = start_extra + 1
    } else if diff == -1 {
      end_extra = end_extra + 1
    } else if diff != 0 {
      return None
    }
  }
  if start_extra > 1 || end_extra > 1 {
    return None
  }

  // Circuit case: pick the first vertex that actually owns an outgoing edge,
  // so an isolated vertex at index 0 does not break the search.
  if start_extra == 0 {
    let mut found = false
    for i = 0; i < n; i = i + 1 {
      if outdeg[i] > 0 {
        start = i
        found = true
        break
      }
    }
    if !found {
      // Defensive: no edges exist (already handled above).
      return Some([])
    }
  }

  // Hierholzer's algorithm.
  let edge_used : Array[Array[Bool]] = []
  for v = 0; v < n; v = v + 1 {
    let oe = g.out_edges(v)
    let used : Array[Bool] = []
    for _j = 0; _j < oe.length(); _j = _j + 1 {
      used.push(false)
    }
    edge_used.push(used)
  }

  let stack : Array[Int] = [start]
  let path : Array[Int] = []
  let edge_pos : Array[Int] = Array::make(n, 0)

  while stack.length() > 0 {
    let v = stack[stack.length() - 1]
    let oe = g.out_edges(v)
    let mut found = false
    while edge_pos[v] < oe.length() {
      let idx = edge_pos[v]
      if !edge_used[v][idx] {
        edge_used[v][idx] = true
        edge_pos[v] = edge_pos[v] + 1
        let e = g.get_edge(oe[idx])
        stack.push(e.to)
        found = true
        break
      }
      edge_pos[v] = edge_pos[v] + 1
    }
    if !found {
      path.push(v)
      let _ = stack.pop()
    }
  }

  // Reverse to recover the correct visitation order.
  let result : Array[Int] = []
  for k = path.length() - 1; k >= 0; k = k - 1 {
    result.push(path[k])
  }

  // A valid Eulerian trail must use every edge exactly once, so the path has
  // exactly `total_edges + 1` vertices. If edges are disconnected, Hierholzer
  // cannot reach them and this length check rejects the graph.
  if result.length() != total_edges + 1 {
    return None
  }
  Some(result)
}

///|
/// Eulerian trail/circuit for the **underlying undirected** graph.
///
/// Each directed edge `u -> v` is treated as an undirected edge between `u` and
/// `v`. Self-loops and parallel edges are handled. Returns `Some(path)` or
/// `None` when no undirected Eulerian trail exists.
///
/// # Conditions
/// - Circuit: every vertex has even degree (within one connected component).
/// - Trail: exactly two vertices have odd degree (one is the start).
///
/// Isolated vertices are ignored. All edges must belong to a single connected
/// component, which is enforced by the final length check.
pub fn eulerian_trail_undirected(g : @graph.Graph[Int, Int]) -> Array[Int]? {
  let n = g.node_count()
  if n == 0 {
    return Some([])
  }

  let deg : Array[Int] = Array::make(n, 0)
  let mut total_edges = 0
  for v = 0; v < n; v = v + 1 {
    let oe = g.out_edges(v)
    for j = 0; j < oe.length(); j = j + 1 {
      let e = g.get_edge(oe[j])
      // An undirected edge contributes 1 to each endpoint; a self-loop adds 2.
      deg[v] = deg[v] + 1
      deg[e.to] = deg[e.to] + 1
      total_edges = total_edges + 1
    }
  }
  if total_edges == 0 {
    return Some([])
  }

  let mut odd = 0
  let mut start = -1
  for i = 0; i < n; i = i + 1 {
    if deg[i] % 2 == 1 {
      odd = odd + 1
      start = i
    }
  }
  if odd != 0 && odd != 2 {
    return None
  }
  if odd == 0 {
    // Circuit: start from any vertex that owns an edge.
    let mut found = false
    for i = 0; i < n; i = i + 1 {
      if deg[i] > 0 {
        start = i
        found = true
        break
      }
    }
    if !found {
      return Some([])
    }
  }

  // Undirected adjacency: each edge is reachable from both endpoints. We store
  // (neighbor, src, pos) so the same global `used[src][pos]` flag covers both
  // traversal directions. Each vertex gets its OWN adjacency/used array (a loop
  // is used instead of `Array::make(n, [])`, which would share one reference).
  let adj : Array[Array[(Int, Int, Int)]] = []
  let used : Array[Array[Bool]] = []
  for _v = 0; _v < n; _v = _v + 1 {
    adj.push([])
    used.push([])
  }
  for v = 0; v < n; v = v + 1 {
    let oe = g.out_edges(v)
    for j = 0; j < oe.length(); j = j + 1 {
      let e = g.get_edge(oe[j])
      adj[v].push((e.to, v, j))
      used[v].push(false)
      if e.to != v {
        // Reverse direction reuses the SAME `used[v][j]` flag.
        adj[e.to].push((v, v, j))
      }
    }
  }

  let stack : Array[Int] = [start]
  let path : Array[Int] = []
  let pos : Array[Int] = Array::make(n, 0)

  while stack.length() > 0 {
    let v = stack[stack.length() - 1]
    let mut found = false
    while pos[v] < adj[v].length() {
      let (nb, src, p) = adj[v][pos[v]]
      pos[v] = pos[v] + 1
      if !used[src][p] {
        used[src][p] = true
        stack.push(nb)
        found = true
        break
      }
    }
    if !found {
      path.push(v)
      let _ = stack.pop()
    }
  }

  let result : Array[Int] = []
  for k = path.length() - 1; k >= 0; k = k - 1 {
    result.push(path[k])
  }
  if result.length() != total_edges + 1 {
    return None
  }
  Some(result)
}
