///|
test "articulation_basic_bridge" {
  // Simple bridge: 0 -- 1 -- 2 (two edges)
  // Edge (0,1) is a bridge, edge (1,2) is a bridge
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  // Add undirected edges as pairs of directed edges
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n0, 1) // reverse
  let _ = g.add_edge(n1, n2, 1)
  let _ = g.add_edge(n2, n1, 1) // reverse

  let (ap, bridges) = articulation_points_and_bridges(g)

  // Node 1 should be an articulation point
  assert_eq(ap[n1], true)

  // Both edges should be bridges
  assert_eq(bridges.length(), 2)
}

///|
test "articulation_no_cut_vertex" {
  // Triangle: 0-1-2-0 (no articulation points, no bridges)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n0, 1)
  let _ = g.add_edge(n1, n2, 1)
  let _ = g.add_edge(n2, n1, 1)
  let _ = g.add_edge(n2, n0, 1)
  let _ = g.add_edge(n0, n2, 1)

  let (ap, bridges) = articulation_points_and_bridges(g)
  assert_eq(ap[0], false)
  assert_eq(ap[1], false)
  assert_eq(ap[2], false)
  assert_eq(bridges.length(), 0)
}

///|
test "articulation_complex" {
  //    0---1---2
  //    |   |
  //    3---4
  //
  // Node 1 connects to both components - it's a cut vertex
  // Edges: 0-1, 1-2, 0-3, 3-4, 1-4
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let n3 = g.add_node(3)
  let n4 = g.add_node(4)

  fn add_undirected(g : @graph.Graph[Int, Int], a : Int, b : Int) -> Unit {
    let _ = g.add_edge(a, b, 1)
    let _ = g.add_edge(b, a, 1)
  }

  add_undirected(g, n0, n1)
  add_undirected(g, n1, n2)
  add_undirected(g, n0, n3)
  add_undirected(g, n3, n4)
  add_undirected(g, n1, n4)

  let (ap, _) = articulation_points_and_bridges(g)
  // Node 1 should be articulation point (removing it disconnects the graph)
  assert_eq(ap[n1], true)
}

///|
test "articulation_single_node" {
  // Single node with self-loop: not an articulation point
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let (ap, bridges) = articulation_points_and_bridges(g)
  assert_eq(ap[0], false)
  assert_eq(bridges.length(), 0)
}
