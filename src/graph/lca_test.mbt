/// Tests for Lowest Common Ancestor (binary lifting).

///|
test "lca_chain" {
  // Chain 0-1-2-3-4 rooted at 0.
  let g = graph_from_edges(5, [(0, 1, 1), (1, 2, 1), (2, 3, 1), (3, 4, 1)])
  let l = LCA::from_tree(g, 0)
  assert_eq(l.query(4, 3), 3)
  assert_eq(l.query(4, 2), 2)
  assert_eq(l.query(4, 0), 0)
  assert_eq(l.query(1, 1), 1)
  assert_eq(l.query(2, 4), 2)
  assert_eq(l.query(0, 4), 0)
}

///|
test "lca_balanced" {
  // Root 0; children 1,2; 1's children 3,4; 2's children 5,6.
  let g = graph_from_edges(
    7,
    [
      (0, 1, 1),
      (0, 2, 1),
      (1, 3, 1),
      (1, 4, 1),
      (2, 5, 1),
      (2, 6, 1),
    ],
  )
  let l = LCA::from_tree(g, 0)
  assert_eq(l.query(3, 4), 1)
  assert_eq(l.query(5, 6), 2)
  assert_eq(l.query(3, 5), 0)
  assert_eq(l.query(0, 3), 0)
  assert_eq(l.query(4, 4), 4)
}

///|
test "lca_star" {
  // Star centered at 0.
  let g = graph_from_edges(5, [(0, 1, 1), (0, 2, 1), (0, 3, 1), (0, 4, 1)])
  let l = LCA::from_tree(g, 0)
  assert_eq(l.query(1, 4), 0)
  assert_eq(l.query(2, 3), 0)
  assert_eq(l.query(1, 1), 1)
}

///|
test "lca_single_node" {
  let g = graph_from_edges(1, [])
  let l = LCA::from_tree(g, 0)
  assert_eq(l.query(0, 0), 0)
}

///|
test "lca_unreachable" {
  // 0 and 1 disconnected from root's component (root=0 only).
  let g = graph_from_edges(3, [(1, 2, 1)])
  let l = LCA::from_tree(g, 0)
  // Node 1 not reachable from root 0 -> -1 sentinel.
  assert_eq(l.query(1, 2), -1)
}
