///|
test "floyd_warshall_basic" {
  //    1
  //  0/ \2
  //   \ /
  //    2
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, 2)
  let _ = g.add_edge(n0, n2, 4)
  let (dist, nxt) = floyd_warshall(g)
  assert_eq(dist[0][0], 0)
  assert_eq(dist[0][1], 1)
  assert_eq(dist[0][2], 3)  // 0->1->2 = 3, not direct 4
  assert_eq(dist[1][2], 2)

  // Path reconstruction
  let path = fw_path(nxt, n0, n2)
  assert_eq(path.length(), 3)
  assert_eq(path[0], 0)
  assert_eq(path[1], 1)
  assert_eq(path[2], 2)
}

///|
test "floyd_warshall_disconnected" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(1)
  let (dist, _) = floyd_warshall(g)
  assert_eq(dist[0][1], 2147483647)  // unreachable
  assert_eq(dist[1][0], 2147483647)  // unreachable
}

///|
test "floyd_warshall_negative_edge" {
  // 0 -> 1 (weight -3), 1 -> 2 (weight 5), 0 -> 2 (weight 100)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, -3)
  let _ = g.add_edge(n1, n2, 5)
  let _ = g.add_edge(n0, n2, 100)
  let (dist, _) = floyd_warshall(g)
  assert_eq(dist[0][2], 2)  // 0->1(-3) + 1->2(5) = 2 < 100
}
