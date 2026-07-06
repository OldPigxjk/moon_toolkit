/// Tests for graph vertex coloring algorithms.

///|
test "coloring_triangle" {
  // A triangle (3 mutually adjacent nodes) needs exactly 3 colors.
  let g = graph_from_edges(3, [(0, 1, 1), (1, 2, 1), (2, 0, 1)])
  let c1 = graph_coloring_welsh_powell(g)
  let c2 = graph_coloring_dsatur(g)
  assert_eq(is_proper_coloring(g, c1), true)
  assert_eq(is_proper_coloring(g, c2), true)
  assert_eq(chromatic_number(c1), 3)
  assert_eq(chromatic_number(c2), 3)
}

///|
test "coloring_bipartite" {
  // Tree 0-2-1-3 is bipartite -> 2 colors suffice.
  let g = graph_from_edges(4, [(0, 2, 1), (1, 2, 1), (1, 3, 1)])
  let c = graph_coloring_dsatur(g)
  assert_eq(is_proper_coloring(g, c), true)
  assert_true(chromatic_number(c) <= 2)
}

///|
test "coloring_single_node" {
  let g = graph_from_edges(1, [])
  let c = graph_coloring_welsh_powell(g)
  assert_eq(chromatic_number(c), 1)
  assert_eq(is_proper_coloring(g, c), true)
}

///|
test "coloring_path" {
  // Path 0->1->2->3 needs only 2 colors.
  let g = graph_from_edges(4, [(0, 1, 1), (1, 2, 1), (2, 3, 1)])
  let c = graph_coloring_welsh_powell(g)
  assert_eq(is_proper_coloring(g, c), true)
  assert_true(chromatic_number(c) <= 2)
}
