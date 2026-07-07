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

// ---- Additional shortest-path boundary cases ----

///|
test "boundary_dijkstra_unreachable" {
  // 0 -> 1, vertex 2 isolated and unreachable from 0.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let _ = g.add_node(2)
  let _ = g.add_edge(n0, n1, 5)
  let (dist, pred) = dijkstra(g, n0)
  assert_eq(dist[1], 5)
  assert_eq(dist[2], 2147483647) // unreachable
  assert_eq(pred[2], -1)
}

///|
test "boundary_dijkstra_start_out_of_range" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let (dist, pred) = dijkstra(g, 7)
  assert_eq(dist[0], 2147483647)
  assert_eq(pred[0], -1)
}

///|
test "boundary_floyd_disconnected" {
  // Two independent edges 0->1 and 2->3.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let n3 = g.add_node(3)
  let _ = g.add_edge(n0, n1, 2)
  let _ = g.add_edge(n2, n3, 4)
  let (dist, _nxt) = floyd_warshall(g)
  assert_eq(dist[0][1], 2)
  assert_eq(dist[2][3], 4)
  assert_eq(dist[0][3], 2147483647)
  assert_eq(dist[2][1], 2147483647)
  assert_eq(dist[0][0], 0)
}

///|
test "boundary_bellman_ford_negative_cycle" {
  // Cycle 0->1->2->0 with negative total weight.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, -1)
  let _ = g.add_edge(n2, n0, -1)
  let r = bellman_ford(g, n0)
  assert_true(r is None)
}

///|
test "boundary_bellman_ford_unreachable" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let _ = g.add_node(2)
  let _ = g.add_edge(n0, n1, 3)
  match bellman_ford(g, n0) {
    Some((dist, _pred)) => {
      assert_eq(dist[1], 3)
      assert_eq(dist[2], 2147483647)
    }
    None => assert_eq(1, 0)
  }
}
