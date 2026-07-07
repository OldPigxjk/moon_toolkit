///|
/// Articulation points (cut vertices) and bridges in an undirected graph.
/// Uses Tarjan's DFS-based algorithm.
/// Time complexity: O(V + E).
///
/// Input Graph edges are treated as undirected.
/// Returns: (is_articulation[], bridge_list[])
pub fn articulation_points_and_bridges(
  g : @graph.Graph[Int, Int],
) -> (Array[Bool], Array[(Int, Int)]) {
  let n = g.node_count()
  if n == 0 {
    return ([], [])
  }

  // Step1: declare all variables
  let visited : Array[Bool] = Array::make(n, false)
  let disc : Array[Int] = Array::make(n, 0)
  let low : Array[Int] = Array::make(n, 0)
  let parent : Array[Int] = Array::make(n, -1)
  let ap : Array[Bool] = Array::make(n, false)
  let bridges : Array[(Int, Int)] = []
  let mut time = 0

  // Step2: define inner function
  fn ap_dfs(u : Int, par : Int) -> Int {
    visited[u] = true
    disc[u] = time
    low[u] = time
    time = time + 1
    let mut children = 0

    let nbrs = g.neighbors(u)
    for i = 0; i < nbrs.length(); i = i + 1 {
      let v = nbrs[i]

      if !visited[v] {
        children = children + 1
        parent[v] = u
        let _ = ap_dfs(v, u)
        low[u] = if low[u] < low[v] { low[u] } else { low[v] }

        // Articulation point check (non-root)
        if par != -1 && low[v] >= disc[u] {
          ap[u] = true
        }

        // Bridge check
        if low[v] > disc[u] {
          bridges.push((u, v))
        }
      } else if v != par {
        low[u] = if low[u] < disc[v] { low[u] } else { disc[v] }
      }
    }

    // Root of DFS tree: articulation point if 2+ children
    if par == -1 && children > 1 {
      ap[u] = true
    }

    children
  }

  // Step3: main logic
  for i = 0; i < n; i = i + 1 {
    if !visited[i] {
      let _c = ap_dfs(i, -1)
    }
  }

  (ap, bridges)
}
