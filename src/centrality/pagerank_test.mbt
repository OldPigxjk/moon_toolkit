///|
/// Test for PageRank and eigenvector centrality

// Absolute value of a Double (test helper).
fn dabs(x : Double) -> Double {
  if x < 0.0 {
    -x
  } else {
    x
  }
}

// Build a directed graph from a flat list of (u, v) edges.

///|
fn build_d(n : Int, edges : Array[(Int, Int)]) -> @graph.Graph[Int, Int] {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < n; i = i + 1 {
    let _ = g.add_node(0)
  }
  for k = 0; k < edges.length(); k = k + 1 {
    let (u, v) = edges[k]
    let _ = g.add_edge(u, v, 1)
  }
  g
}

// Build an undirected graph from a flat list of (u, v) edges.

///|
fn build_u(n : Int, edges : Array[(Int, Int)]) -> @graph.Graph[Int, Int] {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < n; i = i + 1 {
    let _ = g.add_node(0)
  }
  for k = 0; k < edges.length(); k = k + 1 {
    let (u, v) = edges[k]
    let _ = g.add_edge(u, v, 1)
    let _ = g.add_edge(v, u, 1)
  }
  g
}

///|
test "pagerank_2_cycle_symmetric" {
  let g = build_d(2, [(0, 1), (1, 0)])
  let pr = pagerank(g, 0.85, 200, 0.000000001)
  assert_true(dabs(pr[0] - pr[1]) < 0.000001)
  assert_true(dabs(pr[0] + pr[1] - 1.0) < 0.000001)
}

///|
test "pagerank_pointed_node_higher" {
  // Both 1 and 2 link to 0.
  let g = build_d(3, [(1, 0), (2, 0)])
  let pr = pagerank(g, 0.85, 200, 0.000000001)
  assert_true(pr[0] > pr[1])
  assert_true(pr[0] > pr[2])
  let s = pr[0] + pr[1] + pr[2]
  assert_true(dabs(s - 1.0) < 0.000001)
}

///|
test "pagerank_dangling_sink_highest" {
  // 0->1 and 2->1; node 1 is a dangling sink.
  let g = build_d(3, [(0, 1), (2, 1)])
  let pr = pagerank(g, 0.85, 200, 0.000000001)
  assert_true(pr[1] > pr[0])
  assert_true(pr[1] > pr[2])
  let s = pr[0] + pr[1] + pr[2]
  assert_true(dabs(s - 1.0) < 0.000001)
}

///|
test "eigenvector_star_center_highest" {
  // Star centered at 0 (undirected).
  let g = build_u(4, [(0, 1), (0, 2), (0, 3)])
  let ec = eigenvector_centrality(g, 200)
  assert_true(ec[0] > ec[1])
  assert_true(ec[0] > ec[2])
  assert_true(ec[0] > ec[3])
}

///|
test "eigenvector_triangle_equal" {
  // Undirected triangle: all nodes equally central.
  let g = build_u(3, [(0, 1), (1, 2), (2, 0)])
  let ec = eigenvector_centrality(g, 200)
  assert_true(dabs(ec[0] - ec[1]) < 0.000001)
  assert_true(dabs(ec[1] - ec[2]) < 0.000001)
}
