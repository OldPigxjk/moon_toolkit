/// Eulerian trail/circuit using Hierholzer's algorithm for directed graphs.
///
/// Returns Some(path) with node ids, or None if no Eulerian trail exists.
///
/// Conditions:
/// - Circuit: all vertices have equal in/out degree (in one SCC component)
/// - Trail: at most one vertex has out-in=1 (start), one has in-out=1 (end)

pub fn eulerian_trail(g : @graph.Graph[Int, Int]) -> Option[Array[Int]] {
  let n = g.node_count()
  if n == 0 { return Some([]) }

  let indeg : Array[Int] = Array::make(n, 0)
  let outdeg : Array[Int] = Array::make(n, 0)
  let mut total_edges = 0

  // Count in-degrees and out-degrees
  for v = 0; v < n; v = v + 1 {
    let oe = g.out_edges(v)
    outdeg[v] = oe.length()
    total_edges = total_edges + oe.length()
    for j = 0; j < oe.length(); j = j + 1 {
      let e = g.get_edge(oe[j])
      indeg[e.to] = indeg[e.to] + 1
    }
  }

  if total_edges == 0 { return Some([]) }

  // Check Eulerian feasibility and find start node
  let mut start = 0
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

  if start_extra > 1 || end_extra > 1 { return None }

  // Hierholzer's algorithm
  let edge_used : Array[Array[Bool]] = []
  for v = 0; v < n; v = v + 1 {
    let oe = g.out_edges(v)
    let used : Array[Bool] = []
    for _j = 0; _j < oe.length(); _j = _j + 1 { used.push(false) }
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

  // Reverse to get correct order
  let result : Array[Int] = []
  for k = path.length() - 1; k >= 0; k = k - 1 {
    result.push(path[k])
  }

  if result.length() != total_edges + 1 { return None }
  Some(result)
}
