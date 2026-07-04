///|
test "eulerian_circuit" {
  // Simple cycle: 0 -> 1 -> 2 -> 0
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, 1)
  let _ = g.add_edge(n2, n0, 1)

  match eulerian_trail(g) {
    Some(path) => {
      assert_eq(path.length(), 4)  // 3 edges + 1 = 4 nodes
      // Should start and end at same node (circuit)
      assert_eq(path[0], path[3])
    }
    None => { assert_eq(1, 0) }  // fail: should find circuit
  }
}

///|
test "eulerian_trail" {
  // Trail (not circuit): 0 -> 1 -> 2 -> 1 -> 3
  // indeg: 0=0, 1=2, 2=1, 3=1
  // outdeg: 0=1, 1=2, 2=1, 3=0
  // diff: 0=+1(start), 1=0, 2=0, 3=-1(end) => valid trail
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let n3 = g.add_node(3)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, 1)
  let _ = g.add_edge(n2, n1, 1)
  let _ = g.add_edge(n1, n3, 1)

  match eulerian_trail(g) {
    Some(path) => {
      assert_eq(path.length(), 5)  // 4 edges + 1 = 5 nodes
      // Should start at node with out-in=1 (node 0)
      assert_eq(path[0], 0)
    }
    None => { assert_eq(1, 0) }
  }
}

///|
test "eulerian_none" {
  // Disconnected edge: 0->1, 2->3 (no Eulerian trail possible)
  // Node 0: out=1 in=0 diff=+1
  // Node 1: out=0 in=1 diff=-1
  // Node 2: out=1 in=0 diff=+1  <-- second start! Invalid.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(1)
  let _ = g.add_node(2)
  let _ = g.add_node(3)
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(2, 3, 1)

  match eulerian_trail(g) {
    Some(_) => { assert_eq(1, 0) }  // should not find a trail
    None => { assert_eq(1, 1) }     // correct: no trail
  }
}

///|
test "eulerian_single_edge" {
  // Just one edge: 0 -> 1
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(1)
  let _ = g.add_edge(0, 1, 1)

  match eulerian_trail(g) {
    Some(path) => {
      assert_eq(path.length(), 2)
      assert_eq(path[0], 0)
      assert_eq(path[1], 1)
    }
    None => { assert_eq(1, 0) }
  }
}
