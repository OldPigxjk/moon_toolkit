/// Test for Kosaraju's Strongly Connected Components algorithm

// BFS reachability over directed out-edges (test helper).
fn reachable_k(g: @graph.Graph[Int, Int], s: Int, t: Int) -> Bool {
  if s == t {
    return true
  }
  let n = g.node_count()
  let visited : Array[Bool] = Array::make(n, false)
  let queue : Array[Int] = []
  queue.push(s)
  visited[s] = true
  let mut i = 0
  while i < queue.length() {
    let u = queue[i]
    i = i + 1
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      let v = g.get_edge(out[k]).to
      if v == t {
        return true
      }
      if !visited[v] {
        visited[v] = true
        queue.push(v)
      }
    }
  }
  false
}

// Verify every pair within a component is mutually reachable.
fn check_scc(g: @graph.Graph[Int, Int], comp: Array[Int]) -> Bool {
  for a = 0; a < comp.length(); a = a + 1 {
    for b = a + 1; b < comp.length(); b = b + 1 {
      if !reachable_k(g, comp[a], comp[b]) {
        return false
      }
      if !reachable_k(g, comp[b], comp[a]) {
        return false
      }
    }
  }
  true
}

///|
test "kosaraju_scc_single_node" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let sccs = kosaraju_scc(g)
  assert_eq(sccs.length(), 1)
  assert_eq(sccs[0].length(), 1)
  assert_eq(sccs[0][0], 0)
}

///|
test "kosaraju_scc_two_nodes_no_edges" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let sccs = kosaraju_scc(g)
  assert_eq(sccs.length(), 2)
}

///|
test "kosaraju_scc_two_nodes_cycle" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 0, 1)
  let sccs = kosaraju_scc(g)
  assert_eq(sccs.length(), 1)
  assert_eq(sccs[0].length(), 2)
}

///|
test "kosaraju_scc_classic_two_components" {
  // SCC1 = {0,1,2}, SCC2 = {3,4}
  // 0->1, 1->2, 2->0, 1->3, 2->3, 3->4, 4->3
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < 5; i = i + 1 {
    let _ = g.add_node(0)
  }
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  let _ = g.add_edge(2, 0, 1)
  let _ = g.add_edge(1, 3, 1)
  let _ = g.add_edge(2, 3, 1)
  let _ = g.add_edge(3, 4, 1)
  let _ = g.add_edge(4, 3, 1)

  let sccs = kosaraju_scc(g)
  assert_eq(sccs.length(), 2)
  // Verify mutual reachability within each SCC.
  for c = 0; c < sccs.length(); c = c + 1 {
    assert_true(check_scc(g, sccs[c]))
  }

  let ids = kosaraju_component_ids(g)
  assert_eq(ids.length(), 5)
  // Nodes 0,1,2 share an id; 3,4 share another; the two ids differ.
  assert_eq(ids[0], ids[1])
  assert_eq(ids[1], ids[2])
  assert_eq(ids[3], ids[4])
  assert_true(ids[0] != ids[3])
}
