///|
test "dinic_basic" {
  // Classic example: max flow from 0 to 5 should be 23
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let n3 = g.add_node(3)
  let n4 = g.add_node(4)
  let n5 = g.add_node(5)
  let _ = g.add_edge(n0, n1, 16)
  let _ = g.add_edge(n0, n2, 13)
  let _ = g.add_edge(n1, n3, 12)
  let _ = g.add_edge(n2, n1, 4)
  let _ = g.add_edge(n2, n4, 14)
  let _ = g.add_edge(n3, n2, 9)
  let _ = g.add_edge(n3, n5, 20)
  let _ = g.add_edge(n4, n3, 7)
  let _ = g.add_edge(n4, n5, 4)

  match dinic_max_flow(g, n0, n5) {
    Some(flow) => assert_eq(flow, 23)
    None => assert_eq(1, 0)
  } // fail: should return Some
}

///|
test "dinic_simple" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let s = g.add_node(0)
  let t = g.add_node(1)
  let _ = g.add_edge(s, t, 2)
  match dinic_max_flow(g, s, t) {
    Some(flow) => assert_eq(flow, 2)
    None => assert_eq(1, 0)
  }
}

///|
test "dinic_no_path" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let s = g.add_node(0)
  let t = g.add_node(1)
  // No edge between s and t, max flow = 0
  match dinic_max_flow(g, s, t) {
    Some(flow) => assert_eq(flow, 0)
    None => assert_eq(1, 0)
  }
}
