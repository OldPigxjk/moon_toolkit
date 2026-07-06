/// Tests for graph centrality measures.

///|
test "degree_centrality_cycle" {
  // Directed 3-cycle: each vertex has in-degree 1 and out-degree 1.
  let g = @graph.graph_from_edges(3, [(0, 1, 1), (1, 2, 1), (2, 0, 1)])
  let dc = degree_centrality(g)
  // total degree = 2, denom = n - 1 = 2 -> 2/2 = 1.0
  assert_true(dc[0] == 1.0)
  assert_true(dc[1] == 1.0)
  assert_true(dc[2] == 1.0)
}

///|
test "closeness_centrality_path" {
  // Path 0 -> 1 -> 2.
  let g = @graph.graph_from_edges(3, [(0, 1, 1), (1, 2, 1)])
  let cc = closeness_centrality(g)
  assert_true(cc[0] > 0.0)
  assert_true(cc[0] <= 1.0)
  // Node 2 has no outgoing edges, so it reaches nothing -> closeness 0.
  assert_true(cc[2] == 0.0)
}

///|
test "betweenness_centrality_bridge" {
  // Node 1 is the only bridge between 0 and 2.
  let g = @graph.graph_from_edges(3, [(0, 1, 1), (1, 2, 1)])
  let bc = betweenness_centrality(g)
  // Node 1 lies on the only path 0->2, so it must have the highest betweenness.
  assert_true(bc[1] > bc[0])
  assert_true(bc[1] > bc[2])
}

///|
test "betweenness_centrality_symmetry_cycle" {
  // In a symmetric directed 3-cycle all vertices have equal betweenness.
  let g = @graph.graph_from_edges(3, [(0, 1, 1), (1, 2, 1), (2, 0, 1)])
  let bc = betweenness_centrality(g)
  assert_true(bc[0] == bc[1])
  assert_true(bc[1] == bc[2])
  assert_true(bc[0] > 0.0)
}
