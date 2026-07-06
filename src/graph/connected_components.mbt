/// Connected components of the UNDIRECTED view of the graph.

// Build undirected (deduplicated) adjacency lists.
fn cc_adj(g: Graph[Int, Int]) -> Array[Array[Int]] {
  let n = g.node_count()
  let adj : Array[Array[Int]] = []
  for i = 0; i < n; i = i + 1 {
    adj.push([])
  }
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      let v = g.get_edge(out[k]).to
      let mut has = false
      for m = 0; m < adj[u].length(); m = m + 1 {
        if adj[u][m] == v {
          has = true
        }
      }
      if !has {
        adj[u].push(v)
        let mut has2 = false
        for m = 0; m < adj[v].length(); m = m + 1 {
          if adj[v][m] == u {
            has2 = true
          }
        }
        if !has2 {
          adj[v].push(u)
        }
      }
    }
  }
  adj
}

/// Return a component-id array: `comp[v]` is the 0-based id of the connected
/// component containing vertex v. The number of components equals
/// `max(comp) + 1`.
pub fn connected_components(g: Graph[Int, Int]) -> Array[Int] {
  let n = g.node_count()
  let adj = cc_adj(g)
  let comp : Array[Int] = Array::make(n, -1)
  let mut cid = 0
  for s = 0; s < n; s = s + 1 {
    if comp[s] == -1 {
      let queue : Array[Int] = [s]
      comp[s] = cid
      let mut head = 0
      while head < queue.length() {
        let u = queue[head]
        head = head + 1
        let nbrs = adj[u]
        for i = 0; i < nbrs.length(); i = i + 1 {
          let v = nbrs[i]
          if comp[v] == -1 {
            comp[v] = cid
            queue.push(v)
          }
        }
      }
      cid = cid + 1
    }
  }
  comp
}

/// Number of connected components (undirected view).
pub fn count_components(g: Graph[Int, Int]) -> Int {
  let n = g.node_count()
  if n == 0 {
    return 0
  }
  let mut mx = -1
  let c = connected_components(g)
  for i = 0; i < n; i = i + 1 {
    if c[i] > mx {
      mx = c[i]
    }
  }
  mx + 1
}

/// Whether the undirected view of the graph is a single connected component.
pub fn is_connected(g: Graph[Int, Int]) -> Bool {
  count_components(g) == 1
}
