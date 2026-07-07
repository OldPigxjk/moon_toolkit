/// Graph utility functions for connectivity analysis.
/// Provides BFS-based connectivity checks and component counting.

///|
/// Check if the graph is connected (undirected interpretation).
/// For a directed graph, treats edges as undirected (checks weak connectivity).
/// An empty graph returns false; a single-node graph returns true.
pub fn is_connected(g : @graph.Graph[Int, Int]) -> Bool {
  let n = g.node_count()
  if n <= 0 {
    return false
  }
  if n == 1 {
    return true
  }
  let visited = Array::make(n, false)
  let queue : Array[Int] = [0]
  visited[0] = true
  let mut front = 0
  let mut count = 1
  while front < queue.length() {
    let node = queue[front]
    front = front + 1
    let nbrs = g.neighbors(node)
    for i = 0; i < nbrs.length(); i = i + 1 {
      let v = nbrs[i]
      if !visited[v] {
        visited[v] = true
        queue.push(v)
        count = count + 1
      }
    }
  }
  count == n
}

///|
/// Count the number of weakly connected components in the graph.
/// Uses BFS traversal from each unvisited node.
pub fn component_count(g : @graph.Graph[Int, Int]) -> Int {
  let n = g.node_count()
  if n <= 0 {
    return 0
  }
  let visited = Array::make(n, false)
  let mut components = 0
  for start = 0; start < n; start = start + 1 {
    if !visited[start] {
      components = components + 1
      let queue : Array[Int] = [start]
      visited[start] = true
      let mut front = 0
      while front < queue.length() {
        let node = queue[front]
        front = front + 1
        let nbrs = g.neighbors(node)
        for i = 0; i < nbrs.length(); i = i + 1 {
          let v = nbrs[i]
          if !visited[v] {
            visited[v] = true
            queue.push(v)
          }
        }
      }
    }
  }
  components
}
