///|
test "kuhn_basic" {
  // U0 -> V0, V1
  // U1 -> V1
  // U2 -> V0, V2
  // Maximum matching = 3 (e.g., U0-V1, U1-none, U2-V0, wait that's only 2)
  // Actually: U0-V1, U1-?, U2-V0 = 2... let me recalculate
  // U0 can match to V0 or V1
  // U1 can match to V1
  // U2 can match to V0 or V2
  // Optimal: U0-V1, U2-V0, and no one left for V2 => 2 matches? 
  // Wait: U0-V0, U1-V1, U2-V2 => 3! But U1 can't go to V2.
  // Let me use a simpler example:
  //
  // U0 -> V0
  // U1 -> V0, V1
  // U2 -> V1
  // Optimal: U0-V0, U2-V1 => 2 matches (U1 unmatched)
  // Or: U1-V0, U2-V1 => 2 matches (U0 unmatched)
  // Max = 2
  let adj: Array[Array[Int]] = [
    [0],        // U0 -> V0
    [0, 1],     // U1 -> V0, V1
    [1],        // U2 -> V1
  ]
  let (_, count) = kuhn_bipartite_match(adj, 3, 2)
  assert_eq(count, 2)
}

///|
test "kuhn_perfect_matching" {
  // Complete bipartite K2,2: maximum matching should be 2
  let adj: Array[Array[Int]] = [
    [0, 1],   // U0 -> V0, V1
    [0, 1],   // U1 -> V0, V1
  ]
  let (_, count) = kuhn_bipartite_match(adj, 2, 2)
  assert_eq(count, 2)
}

///|
test "kuhn_empty" {
  // No edges at all
  let adj: Array[Array[Int]] = [[], []]
  let (_, count) = kuhn_bipartite_match(adj, 2, 2)
  assert_eq(count, 0)
}

///|
test "kuhn_larger" {
  // U0->V1, U1->V0,V2, U2->V1,V3, U3->V0,V3, U4->V2
  // Expected max = 4 (one of the 5 left nodes must be unmatched)
  let adj: Array[Array[Int]] = [
    [1],
    [0, 2],
    [1, 3],
    [0, 3],
    [2],
  ]
  let (_, count) = kuhn_bipartite_match(adj, 5, 4)
  assert_eq(count, 4)
}
