///|
/// Kuhn's algorithm for maximum bipartite matching.
/// Time complexity: O(VE).
///
/// `adj`: adjacency list from left part U (size n_left) to right part V (size n_right)
/// Returns: (match_right_array, match_count)
///   match_right[v] = which left node is matched to v, or -1 if unmatched
pub fn kuhn_bipartite_match(
  adj : Array[Array[Int]],
  n_left : Int,
  n_right : Int,
) -> (Array[Int], Int) {
  // Step1: declare all variables
  let match_right : Array[Int] = Array::make(n_right, -1)
  let visited : Array[Bool] = Array::make(n_right, false)
  let mut match_count = 0

  // Step2: define inner function
  fn dfs(u : Int) -> Bool {
    let neighbors = adj[u]
    for i = 0; i < neighbors.length(); i = i + 1 {
      let v = neighbors[i]
      if visited[v] {
        continue
      }
      visited[v] = true
      if match_right[v] == -1 || dfs(match_right[v]) {
        match_right[v] = u
        return true
      }
    }
    false
  }

  // Step3: main logic (no new let declarations)
  for u = 0; u < n_left; u = u + 1 {
    for i = 0; i < n_right; i = i + 1 {
      visited[i] = false
    }
    if dfs(u) {
      match_count = match_count + 1
    }
  }

  (match_right, match_count)
}
