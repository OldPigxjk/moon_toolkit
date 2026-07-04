/// Test for Kruskal's MST algorithm

///|
test "kruskal_mst_basic" {
  // Graph: 3 nodes, edges: 0-1 (weight 1), 1-2 (weight 2), 0-2 (weight 4)
  // MST should be: 0-1 (1), 1-2 (2) = total weight 3
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 0, 1) // Undirected edge
  let _ = g.add_edge(1, 2, 2)
  let _ = g.add_edge(2, 1, 2) // Undirected edge
  let _ = g.add_edge(0, 2, 4)
  let _ = g.add_edge(2, 0, 4) // Undirected edge
  
  let result = kruskal_mst(g)
  match result {
    Some(mst_edges) => {
      // MST should have 2 edges (n-1)
      assert_eq(mst_edges.length(), 2)
      // Calculate total weight
      let mut total_weight = 0
      for i = 0; i < mst_edges.length(); i = i + 1 {
        let (_, _, w) = mst_edges[i]
        total_weight = total_weight + w
      }
      assert_eq(total_weight, 3) // 1 + 2 = 3
    }
    None => fail!("Expected Some(mst_edges), got None")
  }
}

///|
test "kruskal_mst_single_node" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  
  let result = kruskal_mst(g)
  match result {
    Some(mst_edges) => {
      // Single node, no edges
      assert_eq(mst_edges.length(), 0)
    }
    None => fail!("Expected Some(mst_edges), got None")
  }
}

///|
test "kruskal_mst_disconnected" {
  // Two disconnected nodes
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let result = kruskal_mst(g)
  // Graph is disconnected, should return None
  match result {
    Some(_) => fail!("Expected None (disconnected), got Some(mst_edges)")
    None => () // Expected
  }
}
