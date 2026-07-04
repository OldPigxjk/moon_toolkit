///|
test "graph_creation" {
  let g : Graph[Int, Int] = Graph::new()
  let n0 = g.add_node(10)
  let n1 = g.add_node(20)
  let n2 = g.add_node(30)
  assert_eq(g.node_count(), 3)
  assert_eq(g.edge_count(), 0)
}

///|
test "graph_add_edge" {
  let g : Graph[Int, Int] = Graph::new()
  let n0 = g.add_node(10)
  let n1 = g.add_node(20)
  let n2 = g.add_node(30)
  let _ = g.add_edge(n0, n1, 5)
  let _ = g.add_edge(n1, n2, 3)
  assert_eq(g.edge_count(), 2)
  assert_eq(g.has_edge(n0, n1), true)
  assert_eq(g.has_edge(n1, n0), false) // directed graph
}

///|
test "graph_neighbors" {
  let g : Graph[Int, Int] = Graph::new()
  let n0 = g.add_node(10)
  let n1 = g.add_node(20)
  let n2 = g.add_node(30)
  let _ = g.add_edge(n0, n1, 5)
  let _ = g.add_edge(n0, n2, 3)
  let neigh = g.neighbors(n0)
  assert_eq(neigh.length(), 2)
}
