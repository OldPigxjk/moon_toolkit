/// Bipartite (2-colorable) testing of the UNDIRECTED view of the graph.

// Build undirected (deduplicated) adjacency lists.
fn bc_adj(g: Graph[Int, Int]) -> Array[Array[Int]] {
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

/// Whether the undirected view of the graph is bipartite.
pub fn is_bipartite(g: Graph[Int, Int]) -> Bool {
  let n = g.node_count()
  let adj = bc_adj(g)
  let color : Array[Int] = Array::make(n, -1)
  for s = 0; s < n; s = s + 1 {
    if color[s] == -1 {
      let queue : Array[Int] = [s]
      color[s] = 0
      let mut head = 0
      while head < queue.length() {
        let u = queue[head]
        head = head + 1
        let nbrs = adj[u]
        for i = 0; i < nbrs.length(); i = i + 1 {
          let v = nbrs[i]
          if color[v] == -1 {
            color[v] = 1 - color[u]
            queue.push(v)
          } else if color[v] == color[u] {
            return false
          }
        }
      }
    }
  }
  true
}

/// If the graph is bipartite, return `Some(coloring)` where `coloring[v]` is
/// 0 or 1. Returns `None` when the graph is not bipartite.
pub fn bipartite_coloring(g: Graph[Int, Int]) -> Array[Int]? {
  let n = g.node_count()
  let adj = bc_adj(g)
  let color : Array[Int] = Array::make(n, -1)
  for s = 0; s < n; s = s + 1 {
    if color[s] == -1 {
      let queue : Array[Int] = [s]
      color[s] = 0
      let mut head = 0
      while head < queue.length() {
        let u = queue[head]
        head = head + 1
        let nbrs = adj[u]
        for i = 0; i < nbrs.length(); i = i + 1 {
          let v = nbrs[i]
          if color[v] == -1 {
            color[v] = 1 - color[u]
            queue.push(v)
          } else if color[v] == color[u] {
            return None
          }
        }
      }
    }
  }
  Some(color)
}
