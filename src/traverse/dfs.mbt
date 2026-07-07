///|
/// DFS (Depth-First Search) traversal.
pub fn dfs(g : @graph.Graph[Int, Int], start : Int) -> Array[Int] {
  let n = g.node_count()
  let visited = Array::make(n, false)
  let result : Array[Int] = []
  if start < 0 || start >= n {
    return result
  }

  let stack : Array[Int] = [start]

  while stack.length() > 0 {
    let node = stack[stack.length() - 1]
    if !visited[node] {
      visited[node] = true
      result.push(node)
    }
    let nbrs = g.neighbors(node)
    let mut i = nbrs.length() - 1
    let mut found_unvisited = false
    while i >= 0 {
      if !visited[nbrs[i]] {
        stack.push(nbrs[i])
        found_unvisited = true
        break
      }
      i = i - 1
    }
    if !found_unvisited {
      let _ = stack.pop()
    }
  }
  result
}

///|
/// DFS postorder traversal.
pub fn dfs_postorder(g : @graph.Graph[Int, Int], start : Int) -> Array[Int] {
  let n = g.node_count()
  let visited = Array::make(n, false)
  let result : Array[Int] = []
  if start < 0 || start >= n {
    return result
  }

  let stack : Array[Int] = [start]

  while stack.length() > 0 {
    let node = stack[stack.length() - 1]
    if !visited[node] {
      visited[node] = true
    }
    let nbrs = g.neighbors(node)
    let mut i = nbrs.length() - 1
    let mut found_unvisited = false
    while i >= 0 {
      if !visited[nbrs[i]] {
        stack.push(nbrs[i])
        found_unvisited = true
        break
      }
      i = i - 1
    }
    if !found_unvisited {
      let _ = stack.pop()
      result.push(node)
    }
  }
  result
}
