/// Additional tests for BFS: boundary cases and shortest path edge cases

///|
test "bfs_shortest_path_start_equals_end" {
  // When start == end, should return [start]
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)

  // start == end
  let path = bfs_shortest_path(g, 1, 1)
  assert_eq(path.length(), 1)
  assert_eq(path[0], 1)

  // Another case: start == end == 0
  let path0 = bfs_shortest_path(g, 0, 0)
  assert_eq(path0.length(), 1)
  assert_eq(path0[0], 0)
}

///|
test "bfs_shortest_path_no_path" {
  // Two disconnected components
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  // Component A: 0 -> 1
  let _ = g.add_edge(0, 1, 1)
  // Component B: 2 -> 3 (isolated from A)
  let _ = g.add_edge(2, 3, 1)

  let path = bfs_shortest_path(g, 0, 3) // No path from component A to B
  assert_eq(path.length(), 0)
}

///|
test "bfs_invalid_input" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  // Out of range
  assert_eq(bfs_shortest_path(g, -1, 0).length(), 0)
  assert_eq(bfs_shortest_path(g, 0, 99).length(), 0)
}

///|
test "bfs_single_node" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(42)

  let result = bfs(g, 0)
  assert_eq(result.length(), 1)
  assert_eq(result[0], 0)
}
