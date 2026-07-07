///|
/// Tarjan's Strongly Connected Components algorithm.
/// Returns an array of SCCs, where each SCC is an array of node ids.
/// The SCCs are returned in reverse topological order of the SCC DAG.
///
/// Time complexity: O(V + E) where V = node count, E = edge count.
pub fn tarjan_scc(g : @graph.Graph[Int, Int]) -> Array[Array[Int]] {
  let n = g.node_count()
  if n == 0 {
    return []
  }

  // indices[u] = DFS index of node u (-1 if unvisited)
  let indices = Array::make(n, -1)
  // lowlink[u] = lowest index reachable from u via back edges
  let lowlink = Array::make(n, 0)
  // on_stack[u] = true if u is on the SCC stack
  let on_stack = Array::make(n, false)
  // SCC stack
  let scc_stack : Array[Int] = []
  // Result list of SCCs
  let result : Array[Array[Int]] = []
  // DFS index counter
  let mut index_counter = 0

  fn strongconnect(v : Int) -> Unit {
    indices[v] = index_counter
    lowlink[v] = index_counter
    index_counter = index_counter + 1

    scc_stack.push(v)
    on_stack[v] = true

    let out_edges = g.out_edges(v)
    for i = 0; i < out_edges.length(); i = i + 1 {
      let edge_id = out_edges[i]
      let w = g.get_edge(edge_id).to

      if indices[w] == -1 {
        strongconnect(w)
        if lowlink[w] < lowlink[v] {
          lowlink[v] = lowlink[w]
        }
      } else if on_stack[w] {
        if indices[w] < lowlink[v] {
          lowlink[v] = indices[w]
        }
      }
    }

    if lowlink[v] == indices[v] {
      let scc : Array[Int] = []
      let mut done = false
      while !done {
        match scc_stack.pop() {
          Some(w) => {
            on_stack[w] = false
            scc.push(w)
            if w == v {
              done = true
            }
          }
          None => done = true
        }
      }
      result.push(scc)
    }
  }

  for start = 0; start < n; start = start + 1 {
    if indices[start] == -1 {
      strongconnect(start)
    }
  }

  result
}
