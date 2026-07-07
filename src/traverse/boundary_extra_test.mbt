/// Additional boundary and edge case tests for traversal algorithms
/// (only same-package functions are referenced here)

///|
test "topo_sort_empty_graph" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()

  match topo_kahn(g) {
    Some(_) => fail("Empty graph should return None")
    None => ()
  }
}

///|
test "boundary_kosaraju_isolated" {
  // 0 <-> 1 strongly connected; vertex 2 isolated.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let _ = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n0, 1)
  let ids = kosaraju_component_ids(g)
  // 0 and 1 share an SCC; 2 is its own SCC.
  assert_eq(ids[0], ids[1])
  assert_true(ids[2] != ids[0])
  let sccs = kosaraju_scc(g)
  assert_eq(sccs.length(), 2)
}

///|
test "boundary_has_cycle_directed_isolated" {
  // 0 -> 1 plus an isolated vertex 2 -> no cycle.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let _ = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  assert_true(!has_cycle_directed(g))
}

///|
test "boundary_has_cycle_undirected_isolated" {
  // Single edge 0-1 plus isolated 2 -> acyclic.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let _ = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  assert_true(!has_cycle_undirected(g))
}

///|
test "boundary_topo_sort_disconnected" {
  // Two independent chains 0->1 and 2->3.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let n3 = g.add_node(3)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n2, n3, 1)
  match topo_kahn(g) {
    Some(order) => {
      let pos : Array[Int] = Array::make(4, -1)
      for i = 0; i < 4; i = i + 1 {
        pos[order[i]] = i
      }
      assert_true(pos[0] < pos[1])
      assert_true(pos[2] < pos[3])
    }
    None => assert_eq(1, 0)
  }
}
