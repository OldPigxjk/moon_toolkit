/// Tests for transitive closure of a directed graph.

///|
test "tc_chain" {
  // 0->1->2->3
  let g = graph_from_edges(4, [(0, 1, 1), (1, 2, 1), (2, 3, 1)])
  let tc = transitive_closure(g)
  assert_eq(tc[0][0], true)
  assert_eq(tc[0][1], true)
  assert_eq(tc[0][2], true)
  assert_eq(tc[0][3], true)
  assert_eq(tc[1][3], true)
  assert_eq(tc[1][0], false)
  assert_eq(tc[3][0], false)
  assert_eq(tc[2][1], false)
}

///|
test "tc_cycle" {
  // Triangle 0->1->2->0: every node reaches every node.
  let g = graph_from_edges(3, [(0, 1, 1), (1, 2, 1), (2, 0, 1)])
  let tc = transitive_closure(g)
  for i = 0; i < 3; i = i + 1 {
    for j = 0; j < 3; j = j + 1 {
      assert_eq(tc[i][j], true)
    }
  }
}

///|
test "tc_self_loop" {
  let g = graph_from_edges(1, [(0, 0, 1)])
  let tc = transitive_closure(g)
  assert_eq(tc[0][0], true)
}

///|
test "tc_disconnected" {
  // 0->1, node 2 isolated.
  let g = graph_from_edges(3, [(0, 1, 1)])
  let tc = transitive_closure(g)
  assert_eq(tc[0][1], true)
  assert_eq(tc[1][0], false)
  assert_eq(tc[2][2], true) // every node reaches itself
  assert_eq(tc[2][0], false)
  assert_eq(tc[0][2], false)
}

///|
test "tc_empty" {
  let g = graph_from_edges(0, [])
  let tc = transitive_closure(g)
  assert_eq(tc.length(), 0)
}
