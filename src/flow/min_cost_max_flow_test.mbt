/// Tests for the Min-Cost Max-Flow algorithm.

///|
test "mcmf_basic" {
  // 0->1 (cap 3, cost 1), 1->2 (cap 2, cost 2), 0->2 (cap 1, cost 5)
  // Max flow 0->2 is 3; cheapest: send 2 via 0->1->2 (cost 6) + 1 via 0->2 (cost 5).
  let edges : Array[(Int, Int, Int, Int)] = [
    (0, 1, 3, 1),
    (1, 2, 2, 2),
    (0, 2, 1, 5),
  ]
  let (flow, cost) = min_cost_max_flow(3, edges, 0, 2)
  assert_eq(flow, 3)
  assert_eq(cost, 11)
}

///|
test "mcmf_negative_cost" {
  // 0->1 (cap 2, cost -3), 1->2 (cap 2, cost -2)
  // Max flow 2, total cost 2 * (-5) = -10.
  let edges : Array[(Int, Int, Int, Int)] = [
    (0, 1, 2, -3),
    (1, 2, 2, -2),
  ]
  let (flow, cost) = min_cost_max_flow(3, edges, 0, 2)
  assert_eq(flow, 2)
  assert_eq(cost, -10)
}

///|
test "mcmf_unreachable" {
  // 0->1 and 2->3 are disconnected; s=0, t=3 unreachable.
  let edges : Array[(Int, Int, Int, Int)] = [
    (0, 1, 5, 1),
    (2, 3, 5, 1),
  ]
  let (flow, cost) = min_cost_max_flow(4, edges, 0, 3)
  assert_eq(flow, 0)
  assert_eq(cost, 0)
}

///|
test "mcmf_single_edge" {
  // Single edge 0->1 (cap 4, cost 3).
  let edges : Array[(Int, Int, Int, Int)] = [ (0, 1, 4, 3) ]
  let (flow, cost) = min_cost_max_flow(2, edges, 0, 1)
  assert_eq(flow, 4)
  assert_eq(cost, 12)
}
