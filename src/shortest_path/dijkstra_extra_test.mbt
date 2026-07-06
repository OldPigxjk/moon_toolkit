/// Additional tests for Dijkstra: path reconstruction, boundary cases

///|
test "dijkstra_reconstruct_path" {
  // Graph: 0 -> 1 (weight 1), 1 -> 2 (weight 2), 0 -> 2 (weight 4)
  // Shortest 0->2 is via node 1 (total 3)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 2)
  let _ = g.add_edge(0, 2, 4)

  let (_, pred) = dijkstra(g, 0)
  let path = reconstruct_path(pred, 0, 2)

  // Path should be [0, 1, 2]
  assert_eq(path.length(), 3)
  assert_eq(path[0], 0)
  assert_eq(path[1], 1)
  assert_eq(path[2], 2)
}

///|
test "dijkstra_reconstruct_unreachable" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(0)

  // No edge between nodes
  let (dist, pred) = dijkstra(g, n0)

  // Node 1 should be unreachable
  assert_eq(dist[n1], 2147483647)

  // Reconstruct to unreachable node returns empty
  let path = reconstruct_path(pred, n0, n1)
  assert_eq(path.length(), 0)
}

///|
test "dijkstra_single_node" {
  // Single node graph
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(42)

  let (dist, pred) = dijkstra(g, n0)
  assert_eq(dist[0], 0)
  assert_eq(pred[0], 0)

  // Path from node to itself
  let path = reconstruct_path(pred, n0, n0)
  assert_eq(path.length(), 1)
  assert_eq(path[0], 0)
}

///|
test "dijkstra_invalid_start" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)

  let (dist, pred) = dijkstra(g, -1)
  // All INF, all -1 predecessor
  assert_eq(dist[0], 2147483647)
  assert_eq(pred[0], -1)

  let (dist2, _) = dijkstra(g, 99)
  assert_eq(dist2[0], 2147483647)
}

///|
test "dijkstra_parallel_edges_min" {
  // Two parallel edges 0->1 with weights 5 and 2. Shortest is 2.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 1, 5)
  let _ = g.add_edge(0, 1, 2)
  let (dist, _) = dijkstra(g, 0)
  assert_eq(dist[1], 2)
}
