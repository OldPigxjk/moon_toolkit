/// Additional tests for Floyd-Warshall: path reconstruction, edge cases

///|
test "floyd_warshall_path_reconstruction" {
  // Graph: 0->1(5), 1->2(3), 2->3(1), 0->3(10)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 5)
  let _ = g.add_edge(1, 2, 3)
  let _ = g.add_edge(2, 3, 1)
  let _ = g.add_edge(0, 3, 10)

  let (dist, nxt) = floyd_warshall(g)

  // Shortest path 0 -> 3 should be via 1 and 2 (5+3+1=9 < 10)
  assert_eq(dist[0][3], 9)

  // Reconstruct the path
  let path = fw_path(nxt, 0, 3)
  assert_eq(path.length(), 4) // [0, 1, 2, 3]
  assert_eq(path[0], 0)
  assert_eq(path[3], 3)
}

///|
test "floyd_warshall_same_node" {
  // Distance from a node to itself should be 0
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 7)

  let (dist, _) = floyd_warshall(g)
  assert_eq(dist[0][0], 0)
  assert_eq(dist[1][1], 0)
}

///|
test "floyd_warshall_disconnected" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  // Only one edge: 0->1, node 2 isolated
  let _ = g.add_edge(0, 1, 5)

  let (dist, _) = floyd_warshall(g)
  assert_eq(dist[0][1], 5)
  // Node 2 unreachable from anyone except itself
  let unreach_val = dist[0][2]
  assert_true(unreach_val == 2147483647)
}

///|
test "floyd_warshall_single_node" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)

  let (dist, _) = floyd_warshall(g)
  assert_eq(dist[0][0], 0)
}
