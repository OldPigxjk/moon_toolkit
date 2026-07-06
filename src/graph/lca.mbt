/// Lowest Common Ancestor (LCA) of a tree via binary lifting.
///
/// `LCA::from_tree` builds the structure from a `Graph` treated as a tree
/// rooted at `root` (the UNDIRECTED view of the graph must be a tree that
/// contains `root`). `query(u, v)` returns the LCA of nodes `u` and `v`.
/// Preprocessing O(n log n), each query O(log n).

pub struct LCA {
  up: Array[Array[Int]]
  depth: Array[Int]
  logn: Int
}

// Undirected, deduplicated adjacency.
fn lca_adj(g: Graph[Int, Int]) -> Array[Array[Int]] {
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

/// Build the binary-lifting LCA structure rooted at `root`.
pub fn LCA::from_tree(g: Graph[Int, Int], root: Int) -> LCA {
  let n = g.node_count()
  let adj = lca_adj(g)
  let mut lg = 1
  while (1 << lg) <= n {
    lg = lg + 1
  }
  let rows = lg
  let up : Array[Array[Int]] = []
  for i = 0; i < rows; i = i + 1 {
    up.push(Array::make(n, -1))
  }
  let depth : Array[Int] = Array::make(n, -1)

  // BFS from root to set depth and immediate parent (up[0]).
  let queue : Array[Int] = [root]
  depth[root] = 0
  up[0][root] = root
  let mut head = 0
  while head < queue.length() {
    let u = queue[head]
    head = head + 1
    let nbrs = adj[u]
    for i = 0; i < nbrs.length(); i = i + 1 {
      let v = nbrs[i]
      if depth[v] == -1 {
        depth[v] = depth[u] + 1
        up[0][v] = u
        queue.push(v)
      }
    }
  }

  // Fill the lifting table.
  for k = 1; k < rows; k = k + 1 {
    for v = 0; v < n; v = v + 1 {
      let p = up[k - 1][v]
      if p != -1 {
        up[k][v] = up[k - 1][p]
      } else {
        up[k][v] = -1
      }
    }
  }
  { up: up, depth: depth, logn: rows - 1 }
}

/// Lift node `u` up by `d` steps (clamped at the root).
fn LCA::lift(self: LCA, u: Int, d: Int) -> Int {
  let mut x = u
  let mut rem = d
  let mut k = 0
  while rem > 0 {
    if rem % 2 == 1 {
      x = self.up[k][x]
    }
    rem = rem / 2
    k = k + 1
  }
  x
}

/// Return the lowest common ancestor of `u` and `v`.
/// Returns -1 if either node is not reachable from the root (depth -1).
pub fn LCA::query(self: LCA, u: Int, v: Int) -> Int {
  if self.depth[u] < 0 || self.depth[v] < 0 {
    return -1
  }
  let mut a = u
  let mut b = v
  if self.depth[a] < self.depth[b] {
    let t = a
    a = b
    b = t
  }
  a = self.lift(a, self.depth[a] - self.depth[b])
  if a == b {
    return a
  }
  let mut k = self.logn
  while k >= 0 {
    if self.up[k][a] != self.up[k][b] {
      a = self.up[k][a]
      b = self.up[k][b]
    }
    k = k - 1
  }
  self.up[0][a]
}
