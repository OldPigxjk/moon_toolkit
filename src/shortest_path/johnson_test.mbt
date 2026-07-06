/// Tests for Johnson's all-pairs shortest path algorithm.

///|
test "johnson_negative_weights" {
  // Graph: 0->1(1), 1->2(-1), 0->2(2) — no negative cycle.
  // Shortest 0->2 is 0->1->2 = 1 + (-1) = 0.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, -1)
  let _ = g.add_edge(0, 2, 2)

  let result = johnson(g)
  match result {
    None => fail("Expected Some (no negative cycle)")
    Some(d) => {
      assert_eq(d[0][1], 1)
      assert_eq(d[0][2], 0)
      assert_eq(d[1][2], -1)
      assert_eq(d[2][0], 2147483647) // unreachable
    }
  }
}

///|
test "johnson_negative_cycle" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 0, -2) // negative cycle 0<->1
  let result = johnson(g)
  match result {
    Some(_) => fail("Expected None (negative cycle)")
    None => ()
  }
}

///|
test "johnson_matches_floyd_positive" {
  // Positive-weight graph; Johnson matrix must equal Floyd-Warshall matrix.
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 1, 5)
  let _ = g.add_edge(1, 2, 3)
  let _ = g.add_edge(2, 3, 1)
  let _ = g.add_edge(0, 3, 10)

  let jr = johnson(g)
  let (fw, _) = floyd_warshall(g)
  match jr {
    None => fail("Expected Some")
    Some(d) => {
      for i = 0; i < 4; i = i + 1 {
        for k = 0; k < 4; k = k + 1 {
          assert_eq(d[i][k], fw[i][k])
        }
      }
    }
  }
}

///|
test "johnson_single_node" {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let result = johnson(g)
  match result {
    Some(d) => assert_eq(d.length(), 1)
    None => fail("Expected Some for single node")
  }
}
