/// Tests for the A* search algorithm.

///|
test "astar_matches_dijkstra_zero_heuristic" {
  // Graph: 0->1(1), 0->2(4), 1->2(2), 1->3(5), 2->3(1)
  // Shortest 0->3 is 0->1->2->3 = 1+2+1 = 4
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0) // 0
  let _ = g.add_node(0) // 1
  let _ = g.add_node(0) // 2
  let _ = g.add_node(0) // 3
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(0, 2, 4)
  let _ = g.add_edge(1, 2, 2)
  let _ = g.add_edge(1, 3, 5)
  let _ = g.add_edge(2, 3, 1)

  let (dist, pred) = astar(g, 0, 3, fn(_) { 0 })
  assert_eq(dist[3], 4)
  let path = reconstruct_path(pred, 0, 3)
  assert_eq(path.length(), 4)
  assert_eq(path[0], 0)
  assert_eq(path[1], 1)
  assert_eq(path[2], 2)
  assert_eq(path[3], 3)
}

///|
test "astar_admissible_heuristic" {
  // Same graph; admissible heuristic = true remaining cost to node 3.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(0, 2, 4)
  let _ = g.add_edge(1, 2, 2)
  let _ = g.add_edge(1, 3, 5)
  let _ = g.add_edge(2, 3, 1)

  let h = fn(v : Int) -> Int {
    if v == 0 {
      4
    } else if v == 1 {
      3
    } else if v == 2 {
      1
    } else {
      0
    }
  }
  let (dist, pred) = astar(g, 0, 3, h)
  assert_eq(dist[3], 4)
  let path = reconstruct_path(pred, 0, 3)
  assert_eq(path[3], 3)
}

///|
test "astar_start_equals_goal" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 1, 1)
  let (dist, pred) = astar(g, 1, 1, fn(_) { 0 })
  assert_eq(dist[1], 0)
  let path = reconstruct_path(pred, 1, 1)
  assert_eq(path.length(), 1)
  assert_eq(path[0], 1)
}

///|
test "astar_unreachable" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 1, 1) // node 2 isolated
  let (dist, _pred) = astar(g, 0, 2, fn(_) { 0 })
  assert_eq(dist[2], 2147483647)
}
