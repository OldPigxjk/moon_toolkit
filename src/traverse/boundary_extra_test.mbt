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
