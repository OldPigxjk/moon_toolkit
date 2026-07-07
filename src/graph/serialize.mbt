/// Graph serialization utilities.
///
/// `to_dot` exports a graph to the Graphviz DOT format (directed graph),
/// convenient for visualization. `graph_from_edges` is a convenience
/// constructor that builds a `Graph` from a flat list of (u, v, weight)
/// tuples — handy when generating test fixtures or loading results from
/// algorithms such as min-cost max-flow.

///|
/// Export the graph to a Graphviz DOT string (directed graph).
/// Each edge is rendered as `  u -> v [label="weight"];`.
pub fn to_dot(g : Graph[Int, Int]) -> String {
  let mut s = "digraph G {\n"
  let n = g.node_count()
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      let e = g.get_edge(out[k])
      s = s + "  \{u} -> \{e.to} [label=\"\{e.weight}\"];\n"
    }
  }
  s = s + "}\n"
  s
}

///|
/// Build a graph with `n` nodes from a list of (from, to, weight) tuples.
pub fn graph_from_edges(
  n : Int,
  edges : Array[(Int, Int, Int)],
) -> Graph[Int, Int] {
  let g : Graph[Int, Int] = Graph::new()
  for i = 0; i < n; i = i + 1 {
    let _ = g.add_node(0)
  }
  for i = 0; i < edges.length(); i = i + 1 {
    let (u, v, w) = edges[i]
    let _ = g.add_edge(u, v, w)
  }
  g
}
