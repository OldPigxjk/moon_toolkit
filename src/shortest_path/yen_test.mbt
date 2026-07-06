/// Test for Yen's k-shortest paths algorithm

///|
test "yen_two_equal_paths" {
  // 0->1 (1), 0->2 (1), 1->3 (1), 2->3 (1). Two shortest paths of cost 2.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < 4; i = i + 1 {
    let _ = g.add_node(0)
  }
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(0, 2, 1)
  let _ = g.add_edge(1, 3, 1)
  let _ = g.add_edge(2, 3, 1)
  let paths = yen_k_shortest(g, 0, 3, 3)
  assert_eq(paths.length(), 2)
  assert_eq(paths[0].1, 2)
  assert_eq(paths[1].1, 2)
}

///|
test "yen_linear_chain_only_one" {
  // 0->1->2->3 : a single path only.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < 4; i = i + 1 {
    let _ = g.add_node(0)
  }
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  let _ = g.add_edge(2, 3, 1)
  let paths = yen_k_shortest(g, 0, 3, 3)
  assert_eq(paths.length(), 1)
  assert_eq(paths[0].1, 3)
}

///|
test "yen_three_distinct_costs" {
  // 0->1 (1), 1->3 (10)  => 11
  // 0->2 (5), 2->3 (5)   => 10  (shortest)
  // 0->3 (20)            => 20
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < 4; i = i + 1 {
    let _ = g.add_node(0)
  }
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 3, 10)
  let _ = g.add_edge(0, 2, 5)
  let _ = g.add_edge(2, 3, 5)
  let _ = g.add_edge(0, 3, 20)
  let paths = yen_k_shortest(g, 0, 3, 3)
  assert_eq(paths.length(), 3)
  assert_eq(paths[0].1, 10)
  assert_eq(paths[1].1, 11)
  assert_eq(paths[2].1, 20)
}

///|
test "yen_unreachable" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < 3; i = i + 1 {
    let _ = g.add_node(0)
  }
  let _ = g.add_edge(0, 1, 1)
  let paths = yen_k_shortest(g, 0, 2, 3)
  assert_eq(paths.length(), 0)
}

///|
test "yen_src_equals_dst" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let paths = yen_k_shortest(g, 0, 0, 3)
  assert_eq(paths.length(), 1)
  assert_eq(paths[0].1, 0)
}
