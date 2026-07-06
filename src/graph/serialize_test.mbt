/// Tests for graph serialization utilities.

///|
test "to_dot_basic" {
  let g = graph_from_edges(3, [(0, 1, 5), (1, 2, 3), (0, 2, 10)])
  let dot = to_dot(g)
  assert_true(dot.contains("digraph G"))
  assert_true(dot.contains("0 -> 1"))
  assert_true(dot.contains("10"))
}

///|
test "graph_from_edges_roundtrip" {
  let g = graph_from_edges(3, [(0, 1, 2), (1, 2, 4)])
  assert_eq(g.node_count(), 3)
  assert_eq(g.edge_count(), 2)
  assert_eq(g.has_edge(0, 1), true)
  assert_eq(g.has_edge(1, 0), false)
}
