/// Dijkstra's single-source shortest path algorithm for non-negative weights.

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
        let u_dist = dist[u]
        let nbrs = g.neighbors(u)
        for i = 0; i < nbrs.length(); i = i + 1 {
          let v = nbrs[i]
          let out_e = g.out_edges(u)
          let mut found_weight = -1
          for j = 0; j < out_e.length(); j = j + 1 {
            let e = g.get_edge(out_e[j])
            if e.to == v { 
              found_weight = e.weight
              break 
            }
          }
          if found_weight >= 0 && u_dist + found_weight < dist[v] {
            dist[v] = u_dist + found_weight
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
pub fn reconstruct_path(pred: Array[Int], end: Int) -> Array[Int] {
  let path: Array[Int] = []
  if end < 0 || end >= pred.length() || (pred[end] < 0 && end != pred[end]) { return path }
  let mut cur = end
  while cur >= 0 {
    path.push(cur)
    if pred[cur] == cur || pred[cur] < 0 { break }
    cur = pred[cur]
    if path.length() > pred.length() { break }
  }
  let rev: Array[Int] = []
  for k = path.length() - 1; k >= 0; k = k - 1 {
    rev.push(path[k])
  }
  rev
}
