/// Spectral / random-walk centrality measures.

// True if `x` already appears in `arr` (adjacency deduplication helper).
fn contains_adj(arr: Array[Int], x: Int) -> Bool {
  for i = 0; i < arr.length(); i = i + 1 {
    if arr[i] == x {
      return true
    }
  }
  false
}

/// PageRank centrality via power iteration.
///
/// For damping factor `d` (typically 0.85) and `n` vertices:
///   PR(v) = (1-d)/n + d * ( sum_{u -> v} PR(u)/outdeg(u)  +  dangling_mass / n )
/// where `dangling_mass` is the total PageRank of vertices with no out-edges,
/// redistributed uniformly. `iterations` bounds the steps; `tol` is the L1
/// convergence threshold (iteration stops early once met). The returned scores
/// sum to (approximately) 1.
pub fn pagerank(
  g: @graph.Graph[Int, Int],
  damping: Double,
  iterations: Int,
  tol: Double,
) -> Array[Double] {
  let n = g.node_count()
  if n == 0 {
    return []
  }
  let outdeg : Array[Int] = Array::make(n, 0)
  let in_links : Array[Array[Int]] = []
  for i = 0; i < n; i = i + 1 {
    in_links.push([])
  }
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    outdeg[u] = out.length()
    for k = 0; k < out.length(); k = k + 1 {
      let v = g.get_edge(out[k]).to
      in_links[v].push(u)
    }
  }

  let base = 1.0 / n.to_double()
  let n_d = n.to_double()
  let mut pr : Array[Double] = []
  for i = 0; i < n; i = i + 1 {
    pr.push(base)
  }

  let mut iter = 0
  while iter < iterations {
    let mut dangling = 0.0
    for u = 0; u < n; u = u + 1 {
      if outdeg[u] == 0 {
        dangling = dangling + pr[u]
      }
    }
    let next : Array[Double] = []
    let mut diff = 0.0
    for i = 0; i < n; i = i + 1 {
      let mut acc = (1.0 - damping) * base + damping * (dangling / n_d)
      let ins = in_links[i]
      for k = 0; k < ins.length(); k = k + 1 {
        let u = ins[k]
        acc = acc + damping * pr[u] / outdeg[u].to_double()
      }
      next.push(acc)
    }
    for i = 0; i < n; i = i + 1 {
      diff = diff + (if next[i] > pr[i] { next[i] - pr[i] } else { pr[i] - next[i] })
    }
    pr = next
    iter = iter + 1
    if diff < tol {
      break
    }
  }
  pr
}

/// Eigenvector centrality via power iteration (graph treated as UNDIRECTED).
///
/// At each step `x <- A_sym * x`, then `x` is renormalized by its max entry.
/// The principal eigenvector (associated with the largest eigenvalue) is
/// recovered, so a vertex's score grows with the centrality of its neighbors.
/// Vertices with no incident edges converge to 0.
pub fn eigenvector_centrality(
  g: @graph.Graph[Int, Int],
  iterations: Int,
) -> Array[Double] {
  let n = g.node_count()
  if n == 0 {
    return []
  }
  // Symmetric adjacency (each directed edge adds both directions).
  let adj : Array[Array[Int]] = []
  for i = 0; i < n; i = i + 1 {
    adj.push([])
  }
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      let v = g.get_edge(out[k]).to
      if !contains_adj(adj[u], v) {
        adj[u].push(v)
      }
      if !contains_adj(adj[v], u) {
        adj[v].push(u)
      }
    }
  }

  let init = 1.0 / n.to_double()
  let mut x : Array[Double] = []
  for i = 0; i < n; i = i + 1 {
    x.push(init)
  }

  let mut iter = 0
  while iter < iterations {
    // y = (A + I) x : adding the identity keeps the eigenvectors of A
    // unchanged but breaks the +/- eigenvalue symmetry of bipartite graphs,
    // so power iteration converges to the (unique) principal eigenvector.
    let y : Array[Double] = []
    for i = 0; i < n; i = i + 1 {
      let nbrs = adj[i]
      let mut s = 0.0
      for k = 0; k < nbrs.length(); k = k + 1 {
        s = s + x[nbrs[k]]
      }
      y.push(s + x[i])
    }
    let mut m = 0.0
    for i = 0; i < n; i = i + 1 {
      if y[i] > m {
        m = y[i]
      }
    }
    let xnew : Array[Double] = []
    if m > 0.0 {
      for i = 0; i < n; i = i + 1 {
        xnew.push(y[i] / m)
      }
    } else {
      for i = 0; i < n; i = i + 1 {
        xnew.push(y[i])
      }
    }
    x = xnew
    iter = iter + 1
  }
  x
}
