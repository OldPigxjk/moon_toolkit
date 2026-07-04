///|
test "bfs_traversal" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n0, n2, 1)
  let visited = bfs(g, n0)
  assert_eq(visited.length(), 3)
}

///|
test "bfs_shortest_path" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, 1)
  let path = bfs_shortest_path(g, n0, n2)
  assert_eq(path.length(), 3) // [n0, n1, n2]
}
