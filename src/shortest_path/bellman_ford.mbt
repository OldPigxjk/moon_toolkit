pub fn bellman_ford(
  g : @graph.Graph[Int, Int],
  source : Int
) -> (Array[Int], Array[Int])? {
  let n = g.node_count()
  if source < 0 || source >= n {
    return None
  }
  
  // Initialize distances and predecessors
  let dist : Array[Int] = Array::make(n, 2147483647)
  let pred : Array[Int] = Array::make(n, -1)
  dist[source] = 0
  
  // Relax edges V-1 times
  for i = 0; i < n - 1; i = i + 1 {
    let mut updated = false
    for u = 0; u < n; u = u + 1 {
      if dist[u] == 2147483647 {
        continue
      }
      let out_edges = g.out_edges(u)
      for j = 0; j < out_edges.length(); j = j + 1 {
        let edge_id = out_edges[j]
        let edge = g.get_edge(edge_id)
        let v = edge.to
        let weight = g.edge_weight(edge_id)
        if dist[u] + weight < dist[v] {
          dist[v] = dist[u] + weight
          pred[v] = u
          updated = true
        }
      }
    }
    if !updated {
      break
    }
  }
  
  // Check for negative cycles
  for u = 0; u < n; u = u + 1 {
    if dist[u] == 2147483647 {
      continue
    }
    let out_edges = g.out_edges(u)
    for j = 0; j < out_edges.length(); j = j + 1 {
      let edge_id = out_edges[j]
      let edge = g.get_edge(edge_id)
      let v = edge.to
      let weight = g.edge_weight(edge_id)
      if dist[u] + weight < dist[v] {
        // Negative cycle detected
        return None
      }
    }
  }
  
  Some((dist, pred))
}
