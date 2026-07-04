/// Test for Tarjan's Strongly Connected Components algorithm

///|
test "tarjan_scc_single_node" {
  // Single node, no edges
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  
  let sccs = tarjan_scc(g)
  assert_eq(sccs.length(), 1) // Should have 1 SCC
  assert_eq(sccs[0].length(), 1) // SCC should contain 1 node
  assert_eq(sccs[0][0], 0) // Node 0
}

///|
test "tarjan_scc_two_nodes_no_edges" {
  // Two nodes, no edges (not strongly connected)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let sccs = tarjan_scc(g)
  assert_eq(sccs.length(), 2) // Should have 2 SCCs
}

///|
test "tarjan_scc_two_nodes_cycle" {
  // Two nodes with a cycle (strongly connected)
  // 0->1, 1->0
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 0, 1)
  
  let sccs = tarjan_scc(g)
  assert_eq(sccs.length(), 1) // Should have 1 SCC
  assert_eq(sccs[0].length(), 2) // SCC should contain 2 nodes
}

///|
test "tarjan_scc_three_nodes" {
  // Three nodes: 0->1->2, and 2->0 (forming a cycle with 0,1,2)
  // Actually, let's create a simpler graph:
  // 0->1, 1->2, 2->0 (all three in one SCC)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  let _ = g.add_edge(2, 0, 1)
  
  let sccs = tarjan_scc(g)
  assert_eq(sccs.length(), 1) // Should have 1 SCC
  assert_eq(sccs[0].length(), 3) // SCC should contain 3 nodes
}
