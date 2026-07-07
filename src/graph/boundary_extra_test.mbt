///|
test "boundary_tc_isolated_vertex" {
  // node 2 is isolated; nodes 0,1 with a single edge 0 -> 1.
  let g : Graph[Int, Int] = Graph::new()
  let a = g.add_node(0)
  let b = g.add_node(1)
  let _ = g.add_node(2)
  let _ = g.add_edge(a, b, 1)
  let tc = transitive_closure(g)
  // Reflexive (trivial path) for every vertex, including the isolated one.
  assert_true(tc[0][0])
  assert_true(tc[1][1])
  assert_true(tc[2][2])
  // 0 -> 1 is reachable.
  assert_true(tc[0][1])
  // The isolated vertex reaches no other vertex.
  assert_true(!tc[2][0])
  assert_true(!tc[2][1])
  assert_true(!tc[0][2])
}

///|
test "boundary_tc_disconnected" {
  // Two independent edges 0->1 and 2->3.
  let g : Graph[Int, Int] = Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let n3 = g.add_node(3)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n2, n3, 1)
  let tc = transitive_closure(g)
  assert_true(tc[0][1])
  assert_true(!tc[0][3])
  assert_true(!tc[2][1])
}

///|
test "boundary_cc_isolated_vertex" {
  // Undirected view: 0-1 is one component, vertex 2 is isolated.
  let g : Graph[Int, Int] = Graph::new()
  let a = g.add_node(0)
  let b = g.add_node(1)
  let _ = g.add_node(2)
  let _ = g.add_edge(a, b, 1)
  assert_eq(count_components(g), 2)
  let comp = connected_components(g)
  assert_eq(comp[0], comp[1])
  assert_true(comp[2] != comp[0])
  assert_true(!is_connected(g))
}

///|
test "boundary_cc_all_isolated" {
  // Three vertices, no edges -> three singleton components.
  let g : Graph[Int, Int] = Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(1)
  let _ = g.add_node(2)
  assert_eq(count_components(g), 3)
}

///|
test "boundary_bipartite_isolated" {
  // A single edge 0-1 (undirected) is bipartite.
  let g : Graph[Int, Int] = Graph::new()
  let a = g.add_node(0)
  let b = g.add_node(1)
  let _ = g.add_edge(a, b, 1)
  assert_true(is_bipartite(g))
  let col = bipartite_coloring(g)
  assert_true(col is Some(_))
}

///|
test "boundary_bipartite_odd_cycle" {
  // Triangle (undirected odd cycle) is NOT bipartite.
  let g : Graph[Int, Int] = Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, 1)
  let _ = g.add_edge(n2, n0, 1)
  assert_true(!is_bipartite(g))
  assert_true(bipartite_coloring(g) is None)
}

///|
test "boundary_bipartite_disconnected" {
  // Two disjoint edges 0-1 and 2-3 are bipartite.
  let g : Graph[Int, Int] = Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let n3 = g.add_node(3)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n2, n3, 1)
  assert_true(is_bipartite(g))
}
