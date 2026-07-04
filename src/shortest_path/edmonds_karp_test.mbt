/// Test for Edmonds-Karp maximum flow algorithm

///|
test "edmonds_karp_basic" {
  // Create a graph with 4 nodes and 5 edges
  // Source = 0, Sink = 3
  // 0->1 (10), 0->2 (10), 1->2 (2), 1->3 (4), 2->3 (8)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0) // node 0
  let _ = g.add_node(0) // node 1
  let _ = g.add_node(0) // node 2
  let _ = g.add_node(0) // node 3
  
  let _ = g.add_edge(0, 1, 10)
  let _ = g.add_edge(0, 2, 10)
  let _ = g.add_edge(1, 2, 2)
  let _ = g.add_edge(1, 3, 4)
  let _ = g.add_edge(2, 3, 8)
  
  let result = edmonds_karp(g, 0, 3)
  match result {
    Some(flow) => assert_eq(flow, 12) // Max flow should be 12
    None => fail!("Expected Some(flow), got None")
  }
}

///|
test "edmonds_karp_no_path" {
  // Graph with no path from source to sink
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0) // node 0
  let _ = g.add_node(0) // node 1
  
  let result = edmonds_karp(g, 0, 1)
  match result {
    Some(flow) => assert_eq(flow, 0) // No path, flow should be 0
    None => fail!("Expected Some(0), got None")
  }
}

///|
test "edmonds_karp_single_edge" {
  // Graph with a single edge from source to sink
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0) // node 0
  let _ = g.add_node(0) // node 1
  
  let _ = g.add_edge(0, 1, 5)
  
  let result = edmonds_karp(g, 0, 1)
  match result {
    Some(flow) => assert_eq(flow, 5) // Max flow should be 5
    None => fail!("Expected Some(5), got None")
  }
}
