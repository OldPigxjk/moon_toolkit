///|
/// Yen's algorithm for the k shortest loopless paths between two nodes.
///
/// Returns up to `k` distinct paths (as `(node_list, total_cost)` tuples),
/// ordered from shortest to longest. If fewer than `k` loopless paths exist,
/// the returned array is shorter. Based on Dijkstra with edge/node blocking.

// Adjacency list with weights: adj[u] = [(neighbor, weight), ...].
fn build_adj_w(g : @graph.Graph[Int, Int]) -> Array[Array[(Int, Int)]] {
  let n = g.node_count()
  let adj : Array[Array[(Int, Int)]] = []
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    let lst : Array[(Int, Int)] = []
    for k = 0; k < out.length(); k = k + 1 {
      let e = g.get_edge(out[k])
      lst.push((e.to, e.weight))
    }
    adj.push(lst)
  }
  adj
}

// Weight of edge u->v, or 2147483647 if absent.

///|
fn ew(adj : Array[Array[(Int, Int)]], u : Int, v : Int) -> Int {
  let lst = adj[u]
  for i = 0; i < lst.length(); i = i + 1 {
    let (to, w) = lst[i]
    if to == v {
      return w
    }
  }
  2147483647
}

///|
fn edge_blocked(be : Array[(Int, Int)], u : Int, v : Int) -> Bool {
  for i = 0; i < be.length(); i = i + 1 {
    let (a, b) = be[i]
    if a == u && b == v {
      return true
    }
  }
  false
}

///|
fn path_eq(a : Array[Int], b : Array[Int]) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if a[i] != b[i] {
      return false
    }
  }
  true
}

// Dijkstra from src to dst, skipping blocked nodes and blocked edges.
// Returns (path, cost) or None when dst is unreachable.

///|
fn spur_dijkstra(
  adj : Array[Array[(Int, Int)]],
  n : Int,
  src : Int,
  dst : Int,
  blocked : Array[Bool],
  blocked_edges : Array[(Int, Int)],
) -> (Array[Int], Int)? {
  let dist : Array[Int] = Array::make(n, 2147483647)
  let pred : Array[Int] = Array::make(n, -1)
  if src < 0 || src >= n {
    return None
  }
  dist[src] = 0
  pred[src] = src
  let heap = @ds.MinHeap::new()
  let heap = heap.push(src, 0)
  let mut h = heap
  while !h.is_empty() {
    let (opt_u, new_h) = h.pop()
    h = new_h
    match opt_u {
      Some(u) => {
        let u_dist = dist[u]
        if u_dist == 2147483647 {
          continue
        }
        if u == dst {
          break
        }
        let nbrs = adj[u]
        for i = 0; i < nbrs.length(); i = i + 1 {
          let (v, w) = nbrs[i]
          if blocked[v] {
            continue
          }
          if edge_blocked(blocked_edges, u, v) {
            continue
          }
          if w < 0 {
            continue
          }
          let new_dist = u_dist + w
          if new_dist >= 0 && new_dist < dist[v] {
            dist[v] = new_dist
            pred[v] = u
            h = h.push(v, dist[v])
          }
        }
      }
      None => break
    }
  }
  if dist[dst] == 2147483647 {
    return None
  }
  let path = reconstruct_path(pred, src, dst)
  Some((path, dist[dst]))
}

///|
/// Compute up to `k` shortest loopless paths from `src` to `dst`.
/// Each returned element is `(node_list, total_cost)`, ordered by cost.
pub fn yen_k_shortest(
  g : @graph.Graph[Int, Int],
  src : Int,
  dst : Int,
  k : Int,
) -> Array[(Array[Int], Int)] {
  let result : Array[(Array[Int], Int)] = []
  if k <= 0 {
    return result
  }
  if src == dst {
    result.push(([src], 0))
    return result
  }
  let n = g.node_count()
  let adj = build_adj_w(g)
  let blocked0 : Array[Bool] = Array::make(n, false)
  let be0 : Array[(Int, Int)] = []
  match spur_dijkstra(adj, n, src, dst, blocked0, be0) {
    Some((p, c)) => result.push((p, c))
    None => return result
  }

  let mut i = 1
  while i < k {
    let prev = result[i - 1].0
    let len = prev.length()
    let cand : Array[(Array[Int], Int)] = []
    for j = 0; j < len - 1; j = j + 1 {
      let spur = prev[j]
      let root : Array[Int] = []
      for t = 0; t <= j; t = t + 1 {
        root.push(prev[t])
      }
      // block all root nodes except the spur (index j)
      let blocked : Array[Bool] = Array::make(n, false)
      for t = 0; t < j; t = t + 1 {
        blocked[root[t]] = true
      }
      // block edges that reproduce an already-found path sharing this root
      let blocked_edges : Array[(Int, Int)] = []
      for a = 0; a < result.length(); a = a + 1 {
        let pa = result[a].0
        if pa.length() >= j + 2 {
          let mut same = true
          for t = 0; t <= j; t = t + 1 {
            if pa[t] != root[t] {
              same = false
            }
          }
          if same {
            blocked_edges.push((pa[j], pa[j + 1]))
          }
        }
      }
      match spur_dijkstra(adj, n, spur, dst, blocked, blocked_edges) {
        Some((sp, sc)) => {
          let mut root_cost = 0
          for t = 0; t < j; t = t + 1 {
            root_cost = root_cost + ew(adj, root[t], root[t + 1])
          }
          let total_nodes : Array[Int] = []
          for t = 0; t <= j; t = t + 1 {
            total_nodes.push(root[t])
          }
          for t = 1; t < sp.length(); t = t + 1 {
            total_nodes.push(sp[t])
          }
          cand.push((total_nodes, root_cost + sc))
        }
        None => ()
      }
    }
    // choose the lowest-cost candidate not already present in result
    let mut best = -1
    let mut best_cost = 2147483647
    for c = 0; c < cand.length(); c = c + 1 {
      let (cn, cc) = cand[c]
      let mut dup = false
      for r = 0; r < result.length(); r = r + 1 {
        if path_eq(result[r].0, cn) {
          dup = true
        }
      }
      if !dup && cc < best_cost {
        best_cost = cc
        best = c
      }
    }
    if best == -1 {
      break
    }
    result.push(cand[best])
    i = i + 1
  }
  result
}
