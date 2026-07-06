/// Cycle detection for directed and undirected graphs.

// Build directed adjacency lists from the graph.
fn build_adj(g: @graph.Graph[Int, Int]) -> Array[Array[Int]] {
  let n = g.node_count()
  let adj : Array[Array[Int]] = []
  for i = 0; i < n; i = i + 1 {
    adj.push([])
  }
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      adj[u].push(g.get_edge(out[k]).to)
    }
  }
  adj
}

// Build undirected (deduplicated) adjacency lists from the graph.
fn build_undirected_adj(g: @graph.Graph[Int, Int]) -> Array[Array[Int]] {
  let n = g.node_count()
  let adj : Array[Array[Int]] = []
  for i = 0; i < n; i = i + 1 {
    adj.push([])
  }
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      let v = g.get_edge(out[k]).to
      if !contains_node(adj[u], v) {
        adj[u].push(v)
      }
      if !contains_node(adj[v], u) {
        adj[v].push(u)
      }
    }
  }
  adj
}

fn contains_node(arr: Array[Int], x: Int) -> Bool {
  for i = 0; i < arr.length(); i = i + 1 {
    if arr[i] == x {
      return true
    }
  }
  false
}

// Directed DFS for back-edge detection (0=white, 1=gray, 2=black).
fn dfs_cycle_dir(
  u: Int,
  adj: Array[Array[Int]],
  color: Array[Int],
) -> Bool {
  color[u] = 1
  let nbrs = adj[u]
  for i = 0; i < nbrs.length(); i = i + 1 {
    let v = nbrs[i]
    if color[v] == 1 {
      return true // back edge -> cycle
    }
    if color[v] == 0 {
      if dfs_cycle_dir(v, adj, color) {
        return true
      }
    }
  }
  color[u] = 2
  false
}

/// Detect whether the directed graph contains a directed cycle.
pub fn has_cycle_directed(g: @graph.Graph[Int, Int]) -> Bool {
  let n = g.node_count()
  let adj = build_adj(g)
  let color : Array[Int] = Array::make(n, 0)
  let mut found = false
  for i = 0; i < n; i = i + 1 {
    if color[i] == 0 {
      if dfs_cycle_dir(i, adj, color) {
        found = true
      }
    }
  }
  found
}

// Undirected DFS for cycle detection (avoid the parent edge).
fn dfs_cycle_undir(
  u: Int,
  parent: Int,
  adj: Array[Array[Int]],
  visited: Array[Bool],
) -> Bool {
  visited[u] = true
  let nbrs = adj[u]
  for i = 0; i < nbrs.length(); i = i + 1 {
    let v = nbrs[i]
    if !visited[v] {
      if dfs_cycle_undir(v, u, adj, visited) {
        return true
      }
    } else if v != parent {
      return true
    }
  }
  false
}

/// Detect whether the underlying undirected graph contains a cycle.
pub fn has_cycle_undirected(g: @graph.Graph[Int, Int]) -> Bool {
  let n = g.node_count()
  let adj = build_undirected_adj(g)
  let visited : Array[Bool] = Array::make(n, false)
  for i = 0; i < n; i = i + 1 {
    if !visited[i] {
      if dfs_cycle_undir(i, -1, adj, visited) {
        return true
      }
    }
  }
  false
}
