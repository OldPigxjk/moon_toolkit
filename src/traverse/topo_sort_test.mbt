/// Test for topological sort (Kahn's algorithm)

///|
test "topo_sort_basic" {
  // DAG: 0->1, 1->2 (linear chain)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  
  let result = topo_kahn(g)
  match result {
    Some(order) => {
      // Should be [0, 1, 2] or similar valid topological order
      assert_eq(order.length(), 3)
      // Check that 0 comes before 1, and 1 comes before 2
      let pos0 = array_index_of(order, 0)
      let pos1 = array_index_of(order, 1)
      let pos2 = array_index_of(order, 2)
      assert_true(pos0 < pos1 && pos1 < pos2)
    }
    None => fail("Expected Some(order), got None")
  }
}

/// Helper function to find index of element in array
fn array_index_of(arr : Array[Int], x : Int) -> Int {
  for i = 0; i < arr.length(); i = i + 1 {
    if arr[i] == x {
      return i
    }
  }
  -1
}

///|
test "topo_sort_dag" {
  // DAG: 0->1, 0->2, 1->3, 2->3
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(0, 2, 1)
  let _ = g.add_edge(1, 3, 1)
  let _ = g.add_edge(2, 3, 1)
  
  let result = topo_kahn(g)
  match result {
    Some(order) => {
      assert_eq(order.length(), 4)
      // Check that 0 comes before 1 and 2, and 1 and 2 come before 3
      let pos0 = array_index_of(order, 0)
      let pos1 = array_index_of(order, 1)
      let pos2 = array_index_of(order, 2)
      let pos3 = array_index_of(order, 3)
      assert_true(pos0 < pos1 && pos0 < pos2)
      assert_true(pos1 < pos3 && pos2 < pos3)
    }
    None => fail("Expected Some(order), got None")
  }
}

///|
test "topo_sort_cycle" {
  // Graph with cycle: 0->1, 1->2, 2->0
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  let _ = g.add_edge(2, 0, 1)
  
  let result = topo_kahn(g)
  // Should detect cycle and return None
  match result {
    Some(_) => fail("Expected None (cycle), got Some(order)")
    None => () // Expected
  }
}
