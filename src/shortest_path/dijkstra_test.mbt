///|
test "dijkstra_basic" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, 2)
  let _ = g.add_edge(n0, n2, 4)
  let (dist, _) = dijkstra(g, n0)
  assert_eq(dist[n1], 1)
  assert_eq(dist[n2], 3)
}

///|
test "dijkstra_unreachable" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let _ = g.add_edge(n0, n0, 0) // self loop
  let (dist, _) = dijkstra(g, n0)
  assert_eq(dist[n1], 2147483647) // INF
}
