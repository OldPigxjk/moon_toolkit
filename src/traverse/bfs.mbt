/// BFS (Breadth-First Search) traversal.
/// Visits nodes in level order from the given start node.
/// Returns array of visited node ids in BFS order.
/// If start is out of range, returns empty array.
pub fn bfs(g: @graph.Graph[Int, Int], start: Int) -> Array[Int] {
  let n = g.node_count()
  let visited = Array::make(n, false)
  let result: Array[Int] = []
  if start < 0 || start >= n { return result }
  
  let queue: Array[Int] = [start]
  visited[start] = true
  let mut front = 0
  
  while front < queue.length() {
    let node = queue[front]
    front = front + 1
    result.push(node)
    let nbrs = g.neighbors(node)
    for i = 0; i < nbrs.length(); i = i + 1 {
      let v = nbrs[i]
      if !visited[v] {
        visited[v] = true
        queue.push(v)
      }
    }
  }
  result
}

/// BFS shortest path from `start` to `end` in an unweighted graph.
/// Returns array of node ids on the shortest path (including start and end),
/// or empty array if no path exists or inputs are invalid.
/// When start == end, returns [start].
pub fn bfs_shortest_path(g: @graph.Graph[Int, Int], start: Int, end: Int) -> Array[Int] {
  let n = g.node_count()
  if start < 0 || start >= n || end < 0 || end >= n { return [] }
  
  // Special case: start equals end
  if start == end { return [start] }
  
  let visited = Array::make(n, false)
  let pred = Array::make(n, -1)
  
  let queue: Array[Int] = [start]
  visited[start] = true
  let mut found = false
  let mut front = 0
  
  while !found && front < queue.length() {
    let node = queue[front]
    front = front + 1
    let nbrs = g.neighbors(node)
    for i = 0; i < nbrs.length(); i = i + 1 {
      let v = nbrs[i]
      if !visited[v] {
        visited[v] = true
        pred[v] = node
        queue.push(v)
        if v == end {
          found = true
          break
        }
      }
    }
  }
  
  if !found { return [] }
  let path: Array[Int] = []
  let mut cur = end
  while cur >= 0 {
    path.push(cur)
    if cur == start { break }
    cur = pred[cur]
    if path.length() > n { break }
  }
  let rev: Array[Int] = []
  for i = path.length() - 1; i >= 0; i = i - 1 {
    rev.push(path[i])
  }
  rev
}
