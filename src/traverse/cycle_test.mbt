/// Test for cycle detection (directed and undirected)

///|
test "has_cycle_directed_acyclic" {
  // 0->1->2  (DAG)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < 3; i = i + 1 {
    let _ = g.add_node(0)
  }
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  assert_true(has_cycle_directed(g) == false)
}

///|
test "has_cycle_directed_cycle" {
  // 0->1->2->0
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < 3; i = i + 1 {
    let _ = g.add_node(0)
  }
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  let _ = g.add_edge(2, 0, 1)
  assert_true(has_cycle_directed(g))
}

///|
test "has_cycle_directed_self_loop" {
  // 0->0 self-loop
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 0, 1)
  assert_true(has_cycle_directed(g))
}

///|
test "has_cycle_undirected_acyclic_tree" {
  // 0-1-2 tree (built as directed 0->1, 1->2; underlying undirected is acyclic)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < 3; i = i + 1 {
    let _ = g.add_node(0)
  }
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  assert_true(has_cycle_undirected(g) == false)
}

///|
test "has_cycle_undirected_cycle" {
  // triangle 0-1, 1-2, 2-0
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < 3; i = i + 1 {
    let _ = g.add_node(0)
  }
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  let _ = g.add_edge(2, 0, 1)
  assert_true(has_cycle_undirected(g))
}
