/// Additional boundary and edge case tests for shortest-path & MST algorithms
/// (kept in the `shortest_path` package so all referenced functions are in-package)

// ---- Bellman-Ford edge cases ----

///|
test "bellman_ford_single_node" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)

  let result = bellman_ford(g, 0)
  match result {
    Some((dist, _pred)) => assert_eq(dist[0], 0)
    None => fail("Expected Some for single node graph")
  }
}

///|
test "bellman_ford_invalid_source" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)

  // Source out of range should return None
  match bellman_ford(g, -1) {
    Some(_) => fail("Expected None for invalid source")
    None => ()
  }
}

///|
test "bellman_ford_disconnected_unreachable" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0) // node 0
  let _ = g.add_node(0) // node 1 (isolated)

  let result = bellman_ford(g, 0)
  match result {
    Some((dist, _pred)) => {
      assert_eq(dist[0], 0)
      assert_eq(dist[1], 2147483647) // unreachable
    }
    None => fail("Expected Some for disconnected graph")
  }
}

// ---- MST edge cases ----

///|
test "kruskal_empty_graph" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()

  match kruskal_mst(g) {
    Some(_) => fail("Empty graph should return None")
    None => () // Expected
  }
}

///|
test "kruskal_single_node" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(99)

  match kruskal_mst(g) {
    Some(edges) => assert_eq(edges.length(), 0)
    None => fail("Single node should return empty MST")
  }
}

///|
test "prim_empty_graph" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()

  match prim_mst(g) {
    Some(_) => fail("Empty graph should return None")
    None => ()
  }
}
