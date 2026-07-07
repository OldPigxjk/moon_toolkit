/// Test for DFS (depth-first search)

///|
test "dfs_basic" {
  // Graph: 0->1, 1->2 (linear chain)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)

  // DFS from node 0 should visit all nodes
  let visited = dfs(g, 0)
  assert_eq(visited.length(), 3) // Should visit 3 nodes
}

///|
test "dfs_disconnected" {
  // Graph: 0->1, 2 (disconnected)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 1)
  // Node 2 is disconnected

  // DFS from node 0 should visit only nodes 0 and 1
  let visited = dfs(g, 0)
  assert_eq(visited.length(), 2) // Should visit 2 nodes
}

///|
test "dfs_single_node" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)

  let visited = dfs(g, 0)
  assert_eq(visited.length(), 1) // Should visit 1 node
}

///|
test "dfs_cycle" {
  // Graph with cycle: 0->1, 1->2, 2->0
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  let _ = g.add_edge(2, 0, 1)

  // DFS from node 0 should visit all nodes (handling cycle correctly)
  let visited = dfs(g, 0)
  assert_eq(visited.length(), 3) // Should visit 3 nodes
}
