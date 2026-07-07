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
      assert_eq(path.length(), 4) // 3 edges + 1 = 4 nodes
      assert_eq(path[0], path[3]) // circuit: same start/end
      assert_true(is_valid_directed(g, path))
    }
    None => assert_eq(1, 0)
  } // fail: should find circuit
}

///|
test "eulerian_trail" {
  // Trail (not circuit): 0 -> 1 -> 2 -> 1 -> 3
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
      assert_eq(path.length(), 5) // 4 edges + 1 = 5 nodes
      assert_eq(path[0], 0) // starts at the out-in=1 vertex
      assert_true(is_valid_directed(g, path))
    }
    None => assert_eq(1, 0)
  }
}

///|
test "eulerian_none" {
  // Disconnected edge: 0->1, 2->3 (two starts -> invalid)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(1)
  let _ = g.add_node(2)
  let _ = g.add_node(3)
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(2, 3, 1)

  match eulerian_trail(g) {
    Some(_) => assert_eq(1, 0) // should not find a trail
    None => assert_eq(1, 1)
  } // correct: no trail
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
      assert_true(is_valid_directed(g, path))
    }
    None => assert_eq(1, 0)
  }
}

///|
test "eulerian_isolated_vertex_before_cycle" {
  // Vertex 0 is isolated; the real edges form a cycle 1 -> 2 -> 1.
  // The isolated vertex must NOT break the Eulerian circuit of the cycle.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0) // isolated
  let a = g.add_node(1)
  let b = g.add_node(2)
  let _ = g.add_edge(a, b, 1)
  let _ = g.add_edge(b, a, 1)

  match eulerian_trail(g) {
    Some(path) => {
      // 2 edges -> path of length 3
      assert_eq(path.length(), 3)
      assert_true(is_valid_directed(g, path))
    }
    None => assert_eq(1, 0)
  } // fail on the OLD code (wrong start at isolated vertex 0)
}

///|
test "eulerian_isolated_vertex_only" {
  // Single isolated vertex, no edges -> trivial empty trail.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  match eulerian_trail(g) {
    Some(path) => assert_eq(path.length(), 0)
    None => assert_eq(1, 0)
  }
}

///|
test "eulerian_empty_graph" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  match eulerian_trail(g) {
    Some(path) => assert_eq(path.length(), 0)
    None => assert_eq(1, 0)
  }
}

///|
test "eulerian_disconnected_two_cycles" {
  // Two independent cycles 0->1->0 and 2->3->2 share no edges.
  // No single trail can cover all 4 edges -> None.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let n3 = g.add_node(3)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n0, 1)
  let _ = g.add_edge(n2, n3, 1)
  let _ = g.add_edge(n3, n2, 1)

  match eulerian_trail(g) {
    Some(_) => assert_eq(1, 0) // must reject disconnected edges
    None => assert_eq(1, 1)
  }
}

///|
test "eulerian_self_loop" {
  // Self-loop 0 -> 0 forms a circuit of one edge.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let _ = g.add_edge(n0, n0, 1)
  match eulerian_trail(g) {
    Some(path) => {
      assert_eq(path.length(), 2)
      assert_eq(path[0], 0)
      assert_eq(path[1], 0)
      assert_true(is_valid_directed(g, path))
    }
    None => assert_eq(1, 0)
  }
}

///|
test "eulerian_parallel_edges" {
  // Multigraph circuit: two parallel 0->1 and two parallel 1->0.
  // outdeg(0)=2=indeg(0), outdeg(1)=2=indeg(1) -> valid circuit, 4 edges.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n0, 1)
  let _ = g.add_edge(n1, n0, 1)
  match eulerian_trail(g) {
    Some(path) => {
      assert_eq(path.length(), 5) // 4 edges + 1
      assert_true(is_valid_directed(g, path))
    }
    None => assert_eq(1, 0)
  }
}

///|
test "eulerian_trail_with_isolated_suffix" {
  // Circuit 0->1->2->0 plus an isolated vertex 3.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_node(3) // isolated
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, 1)
  let _ = g.add_edge(n2, n0, 1)
  match eulerian_trail(g) {
    Some(path) => {
      assert_eq(path.length(), 4)
      assert_true(is_valid_directed(g, path))
    }
    None => assert_eq(1, 0)
  }
}

// ---- Undirected Eulerian ----

///|
test "eulerian_undirected_circuit" {
  // Undirected cycle 0-1-2-0 (edges stored as directed).
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, 1)
  let _ = g.add_edge(n2, n0, 1)
  match eulerian_trail_undirected(g) {
    Some(path) => {
      assert_eq(path.length(), 4)
      assert_true(is_valid_undirected(g, path))
    }
    None => assert_eq(1, 0)
  }
}

///|
test "eulerian_undirected_trail" {
  // Undirected path 0-1-2 (single edges). Degrees: 0:1, 1:2, 2:1 -> trail.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n1, n2, 1)
  match eulerian_trail_undirected(g) {
    Some(path) => {
      assert_eq(path.length(), 3)
      assert_true(is_valid_undirected(g, path))
    }
    None => assert_eq(1, 0)
  }
}

///|
test "eulerian_undirected_none_four_odd" {
  // Two disconnected undirected edges 0-1 and 2-3 -> 4 odd vertices -> None.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let n1 = g.add_node(1)
  let n2 = g.add_node(2)
  let n3 = g.add_node(3)
  let _ = g.add_edge(n0, n1, 1)
  let _ = g.add_edge(n2, n3, 1)
  match eulerian_trail_undirected(g) {
    Some(_) => assert_eq(1, 0)
    None => assert_eq(1, 1)
  }
}

///|
test "eulerian_undirected_self_loop" {
  // Self-loop gives degree 2 -> even -> circuit.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let n0 = g.add_node(0)
  let _ = g.add_edge(n0, n0, 1)
  match eulerian_trail_undirected(g) {
    Some(path) => {
      assert_eq(path.length(), 2)
      assert_true(is_valid_undirected(g, path))
    }
    None => assert_eq(1, 0)
  }
}

// ---- validity helpers ----

///|
fn collect_edges(g : @graph.Graph[Int, Int]) -> Array[(Int, Int)] {
  let es : Array[(Int, Int)] = []
  let n = g.node_count()
  for v = 0; v < n; v = v + 1 {
    let oe = g.out_edges(v)
    for j = 0; j < oe.length(); j = j + 1 {
      let e = g.get_edge(oe[j])
      es.push((v, e.to))
    }
  }
  es
}

///|
/// Every consecutive pair in `path` must consume a distinct directed edge,
/// and all edges must be consumed.
fn is_valid_directed(g : @graph.Graph[Int, Int], path : Array[Int]) -> Bool {
  let es = collect_edges(g)
  let used = Array::make(es.length(), false)
  for i = 0; i < path.length() - 1; i = i + 1 {
    let u = path[i]
    let v = path[i + 1]
    let mut found = false
    for k = 0; k < es.length(); k = k + 1 {
      if !used[k] {
        let (a, b) = es[k]
        if a == u && b == v {
          used[k] = true
          found = true
          break
        }
      }
    }
    if !found {
      return false
    }
  }
  for k = 0; k < used.length(); k = k + 1 {
    if !used[k] {
      return false
    }
  }
  true
}

///|
/// Same as above but edges may be traversed in either direction.
fn is_valid_undirected(g : @graph.Graph[Int, Int], path : Array[Int]) -> Bool {
  let es = collect_edges(g)
  let used = Array::make(es.length(), false)
  for i = 0; i < path.length() - 1; i = i + 1 {
    let u = path[i]
    let v = path[i + 1]
    let mut found = false
    for k = 0; k < es.length(); k = k + 1 {
      if !used[k] {
        let (a, b) = es[k]
        if (a == u && b == v) || (a == v && b == u) {
          used[k] = true
          found = true
          break
        }
      }
    }
    if !found {
      return false
    }
  }
  for k = 0; k < used.length(); k = k + 1 {
    if !used[k] {
      return false
    }
  }
  true
}
