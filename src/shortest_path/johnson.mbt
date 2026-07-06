/// Johnson's algorithm for all-pairs shortest paths.
///
/// Supports graphs with NEGATIVE edge weights, provided there is NO
/// negative-weight cycle (in which case `None` is returned). It combines
/// Bellman-Ford (to compute vertex potentials / a feasible reweighting) with
/// Dijkstra (run on the reweighted, non-negative graph), achieving
/// O(V·E·log V) overall — faster than Floyd-Warshall's O(V³) for sparse graphs.
///
/// Returns an n×n distance matrix `D` where `D[u][v]` is the shortest distance
/// from `u` to `v` (2147483647 = unreachable). Returns `None` if a negative
/// cycle is detected.
pub fn johnson(g: @graph.Graph[Int, Int]) -> Array[Array[Int]]? {
  let n = g.node_count()
  if n == 0 {
    return Some([])
  }

  // --- Build augmented graph with a super-source Q (node id = n) ---
  // Q has a 0-weight edge to every original node, so it can reach all of them.
  let aug : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < n; i = i + 1 {
    let _ = aug.add_node(0)
  }
  let q = aug.add_node(0) // q == n
  for i = 0; i < n; i = i + 1 {
    let _ = aug.add_edge(q, i, 0)
  }
  // Copy original directed edges into the augmented graph.
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      let e = g.get_edge(out[k])
      let _ = aug.add_edge(e.from, e.to, e.weight)
    }
  }

  // --- Step 1: Bellman-Ford from Q to compute potentials h[v] = dist(Q, v) ---
  let bf = bellman_ford(aug, q)
  match bf {
    None => return None // negative cycle detected
    Some((h, _pred)) => {
      // --- Step 2: reweight edges so all weights become non-negative ---
      // w'(u,v) = w(u,v) + h[u] - h[v]  (guaranteed >= 0 by triangle inequality)
      let rg : @graph.Graph[Int, Int] = @graph.Graph::new()
      for i = 0; i < n; i = i + 1 {
        let _ = rg.add_node(0)
      }
      for u = 0; u < n; u = u + 1 {
        let out = g.out_edges(u)
        for k = 0; k < out.length(); k = k + 1 {
          let e = g.get_edge(out[k])
          let re = e.weight + h[u] - h[e.to]
          let _ = rg.add_edge(e.from, e.to, re)
        }
      }

      // --- Step 3: Dijkstra from every node on the reweighted graph ---
      let result : Array[Array[Int]] = []
      for u = 0; u < n; u = u + 1 {
        let (d, _p) = dijkstra(rg, u)
        let row : Array[Int] = []
        for v = 0; v < n; v = v + 1 {
          if d[v] >= 2147483647 {
            row.push(2147483647)
          } else {
            // true distance = reweighted distance + h[v] - h[u]
            row.push(d[v] + h[v] - h[u])
          }
        }
        result.push(row)
      }
      Some(result)
    }
  }
}
