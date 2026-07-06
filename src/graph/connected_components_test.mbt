/// Tests for connected components (undirected view of the graph).

///|
test "cc_single_component" {
  let g = graph_from_edges(4, [(0, 1, 1), (1, 2, 1), (2, 3, 1), (3, 0, 1)])
  assert_eq(is_connected(g), true)
  assert_eq(count_components(g), 1)
  let c = connected_components(g)
  assert_eq(c[0], c[1])
  assert_eq(c[1], c[2])
  assert_eq(c[2], c[3])
}

///|
test "cc_three_components" {
  // Components: {0,1}, {2}, {3,4,5}
  let g = graph_from_edges(6, [(0, 1, 1), (3, 4, 1), (4, 5, 1), (5, 3, 1)])
  assert_eq(is_connected(g), false)
  assert_eq(count_components(g), 3)
  let c = connected_components(g)
  assert_eq(c[0], c[1])
  assert_eq(c[3], c[4])
  assert_eq(c[4], c[5])
  assert_true(c[2] != c[0])
  assert_true(c[3] != c[0])
  assert_true(c[3] != c[2])
}

///|
test "cc_empty" {
  let g = graph_from_edges(0, [])
  assert_eq(count_components(g), 0)
  assert_eq(is_connected(g), false)
}

///|
test "cc_connected_by_direction" {
  // Single directed edge 0->1: undirected view still links 0 and 1.
  let g = graph_from_edges(2, [(0, 1, 1)])
  assert_eq(is_connected(g), true)
  assert_eq(count_components(g), 1)
}

///|
test "cc_single_node" {
  let g = graph_from_edges(1, [])
  assert_eq(count_components(g), 1)
  assert_eq(is_connected(g), true)
}
