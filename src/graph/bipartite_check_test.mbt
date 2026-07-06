/// Tests for bipartite (2-colorable) checking (undirected view).

///|
test "bipartite_even_cycle" {
  // 4-cycle 0-1-2-3-0 is bipartite.
  let g = graph_from_edges(4, [(0, 1, 1), (1, 2, 1), (2, 3, 1), (3, 0, 1)])
  assert_eq(is_bipartite(g), true)
  let c = bipartite_coloring(g)
  match c {
    Some(col) => {
      assert_eq(col[0] != col[1], true)
      assert_eq(col[1] != col[2], true)
      assert_eq(col[2] != col[3], true)
      assert_eq(col[3] != col[0], true)
    }
    None => { fail("even cycle should be bipartite") }
  }
}

///|
test "bipartite_triangle" {
  // 3-cycle is NOT bipartite.
  let g = graph_from_edges(3, [(0, 1, 1), (1, 2, 1), (2, 0, 1)])
  assert_eq(is_bipartite(g), false)
  assert_true(bipartite_coloring(g) is None)
}

///|
test "bipartite_tree" {
  // Star 0-1, 0-2, 0-3 is bipartite.
  let g = graph_from_edges(4, [(0, 1, 1), (0, 2, 1), (0, 3, 1)])
  assert_eq(is_bipartite(g), true)
  let c = bipartite_coloring(g)
  match c {
    Some(col) => {
      assert_eq(col[1], col[2])
      assert_eq(col[2], col[3])
      assert_eq(col[0] != col[1], true)
    }
    None => { fail("tree should be bipartite") }
  }
}

///|
test "bipartite_single_node" {
  let g = graph_from_edges(1, [])
  assert_eq(is_bipartite(g), true)
  let c = bipartite_coloring(g)
  match c {
    Some(col) => { assert_eq(col[0], 0) }
    None => { fail("single node should be bipartite") }
  }
}

///|
test "bipartite_odd_cycle" {
  // 5-cycle is NOT bipartite.
  let g = graph_from_edges(5, [(0, 1, 1), (1, 2, 1), (2, 3, 1), (3, 4, 1), (4, 0, 1)])
  assert_eq(is_bipartite(g), false)
}
