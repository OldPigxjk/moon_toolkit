pub fn topo_kahn(g : @graph.Graph[Int, Int]) -> Array[Int]? {
  let n = g.node_count()
  if n == 0 {
    return None
  }
  
  // Calculate in-degree for each node
  let in_degree = Array::make(n, 0)
  let m = g.edge_count()
  for i = 0; i < m; i = i + 1 {
    let edge = g.get_edge(i)
    in_degree[edge.to] = in_degree[edge.to] + 1
  }
  
  // Initialize queue with nodes of zero in-degree
  let queue = []
  for i = 0; i < n; i = i + 1 {
    if in_degree[i] == 0 {
      queue.push(i)
    }
  }
  
  // Process nodes
  let result = []
  let mut head : Int = 0
  
  while head < queue.length() {
    let u = queue[head]
    head = head + 1
    result.push(u)
    
    let neighbors = g.neighbors(u)
    for j = 0; j < neighbors.length(); j = j + 1 {
      let v = neighbors[j]
      in_degree[v] = in_degree[v] - 1
      if in_degree[v] == 0 {
        queue.push(v)
      }
    }
  }
  
  if result.length() == n {
    Some(result)
  } else {
    None
  }
}
