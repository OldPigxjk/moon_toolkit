/// Transitive closure of a directed graph via Floyd-Warshall on reachability.
/// Returns an n×n Boolean matrix `tc` where `tc[i][j]` is true iff there is a
/// (possibly trivial, when i == j) directed path from i to j. O(V³).

pub fn transitive_closure(g: Graph[Int, Int]) -> Array[Array[Bool]] {
  let n = g.node_count()
  let tc : Array[Array[Bool]] = []
  for i = 0; i < n; i = i + 1 {
    let row : Array[Bool] = []
    for j = 0; j < n; j = j + 1 {
      if i == j {
        row.push(true)
      } else {
        row.push(g.has_edge(i, j))
      }
    }
    tc.push(row)
  }
  for k = 0; k < n; k = k + 1 {
    for i = 0; i < n; i = i + 1 {
      if tc[i][k] {
        for j = 0; j < n; j = j + 1 {
          if tc[k][j] {
            tc[i][j] = true
          }
        }
      }
    }
  }
  tc
}
