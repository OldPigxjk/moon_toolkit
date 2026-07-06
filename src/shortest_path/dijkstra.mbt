/// Dijkstra's single-source shortest path algorithm for non-negative weights.
/// Returns a tuple of (distances, predecessors) arrays.
/// dist[v] = shortest distance from start to v (2147483647 = unreachable).
/// pred[v] = predecessor node on shortest path (-1 = no predecessor / unreachable).
/// If start is out of range, returns all-INF distances and all-(-1) predecessors.
pub fn dijkstra(g: @graph.Graph[Int, Int], start: Int) -> (Array[Int], Array[Int]) {
  let n = g.node_count()
  let dist = Array::make(n, 2147483647)
  let pred = Array::make(n, -1)
  
  if start < 0 || start >= n { return (dist, pred) }
  
  dist[start] = 0
  pred[start] = start
  let heap = @ds.MinHeap::new()
  let heap = heap.push(start, 0)
  
  let mut h = heap
  while !h.is_empty() {
    let (opt_u, new_h) = h.pop()
    h = new_h
    match opt_u {
      Some(u) => {
        // Skip stale entries
        let u_dist = dist[u]
        if u_dist == 2147483647 { continue }
        // Relax every outgoing edge (handles parallel edges correctly:
        // each edge is considered independently, so the minimum weight wins).
        let out_e = g.out_edges(u)
        for j = 0; j < out_e.length(); j = j + 1 {
          let e = g.get_edge(out_e[j])
          let v = e.to
          let w = e.weight
          // Dijkstra requires non-negative weights; negative weights are ignored
          if w < 0 { continue }
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
  
  (dist, pred)
}

/// Reconstruct the shortest path from `start` to `end` using predecessor array.
/// Returns array of node ids on the path (including start and end), or empty array if no path exists.
/// If end is unreachable or inputs invalid, returns empty array.
pub fn reconstruct_path(pred: Array[Int], start: Int, end: Int) -> Array[Int] {
  let n = pred.length()
  if end < 0 || end >= n || start < 0 || start >= n { return [] }
  let path: Array[Int] = []
  let mut cur = end
  while cur >= 0 && cur < n {
    path.push(cur)
    if cur == start { break }
    if pred[cur] < 0 || pred[cur] >= n { return [] } // broken chain
    cur = pred[cur]
    if path.length() > n + 1 { return [] } // cycle detection
  }
  if cur != start { return [] } // didn't reach start
  let rev: Array[Int] = []
  for k = path.length() - 1; k >= 0; k = k - 1 {
    rev.push(path[k])
  }
  rev
}
