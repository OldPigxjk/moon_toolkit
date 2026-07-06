/// Test for Bellman-Ford algorithm

///|
test "bellman_ford_basic" {
  // Graph: 3 nodes, edges: 0->1 (weight 1), 1->2 (weight 2), 0->2 (weight 4)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 2)
  let _ = g.add_edge(0, 2, 4)
  
  let result = bellman_ford(g, 0)
  match result {
    Some((dist, _pred)) => {
      assert_eq(dist[0], 0)
      assert_eq(dist[1], 1)
      assert_eq(dist[2], 3) // 0->1->2 = 1+2 = 3
    }
    None => fail("Expected Some((dist, pred)), got None")
  }
}

///|
test "bellman_ford_negative_weight" {
  // Graph with negative weight edge (but no negative cycle)
  // 0->1 (weight 1), 1->2 (weight -3), 0->2 (weight 4)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, -3)
  let _ = g.add_edge(0, 2, 4)
  
  let result = bellman_ford(g, 0)
  match result {
    Some((dist, _pred)) => {
      assert_eq(dist[0], 0)
      assert_eq(dist[1], 1)
      assert_eq(dist[2], -2) // 0->1->2 = 1 + (-3) = -2
    }
    None => fail("Expected Some((dist, pred)), got None")
  }
}

///|
test "bellman_ford_negative_cycle" {
  // Graph with negative cycle: 0->1 (weight 1), 1->0 (weight -2)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 0, -2)
  
  let result = bellman_ford(g, 0)
  // Should detect negative cycle and return None
  match result {
    Some(_) => fail("Expected None (negative cycle), got Some((dist, pred))")
    None => () // Expected
  }
}
