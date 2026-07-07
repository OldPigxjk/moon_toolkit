///|
/// Kosaraju's algorithm for finding Strongly Connected Components (SCCs).
///
/// A strongly connected component is a maximal set of vertices where every
/// pair is mutually reachable. Kosaraju runs two DFS passes (the second on
/// the reversed graph) and runs in O(V + E).

// First DFS pass: record vertices in order of finishing time.
fn dfs_kos_1(
  u : Int,
  adj : Array[Array[Int]],
  visited : Array[Bool],
  order : Array[Int],
) -> Unit {
  visited[u] = true
  let nbrs = adj[u]
  for i = 0; i < nbrs.length(); i = i + 1 {
    let v = nbrs[i]
    if !visited[v] {
      dfs_kos_1(v, adj, visited, order)
    }
  }
  order.push(u)
}

// Second DFS pass: explore the reversed graph to collect one SCC.

///|
fn dfs_kos_2(
  u : Int,
  radj : Array[Array[Int]],
  visited : Array[Bool],
  comp : Array[Int],
) -> Unit {
  visited[u] = true
  comp.push(u)
  let nbrs = radj[u]
  for i = 0; i < nbrs.length(); i = i + 1 {
    let v = nbrs[i]
    if !visited[v] {
      dfs_kos_2(v, radj, visited, comp)
    }
  }
}

///|
/// Return the list of strongly connected components.
/// Each component is an array of vertex ids.
pub fn kosaraju_scc(g : @graph.Graph[Int, Int]) -> Array[Array[Int]] {
  let n = g.node_count()
  let adj : Array[Array[Int]] = []
  let radj : Array[Array[Int]] = []
  for i = 0; i < n; i = i + 1 {
    adj.push([])
    radj.push([])
  }
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      let v = g.get_edge(out[k]).to
      adj[u].push(v)
      radj[v].push(u)
    }
  }

  // Pass 1: finishing-time order.
  let visited : Array[Bool] = Array::make(n, false)
  let order : Array[Int] = []
  for i = 0; i < n; i = i + 1 {
    if !visited[i] {
      dfs_kos_1(i, adj, visited, order)
    }
  }

  // Pass 2: traverse reversed graph in reverse finish order.
  let visited2 : Array[Bool] = Array::make(n, false)
  let comps : Array[Array[Int]] = []
  let mut i = order.length() - 1
  while i >= 0 {
    let v = order[i]
    if !visited2[v] {
      let comp : Array[Int] = []
      dfs_kos_2(v, radj, visited2, comp)
      comps.push(comp)
    }
    i = i - 1
  }
  comps
}

///|
/// Return a component-id array: `ids[v]` is the 0-based SCC index of vertex v.
pub fn kosaraju_component_ids(g : @graph.Graph[Int, Int]) -> Array[Int] {
  let comps = kosaraju_scc(g)
  let n = g.node_count()
  let ids : Array[Int] = Array::make(n, -1)
  for c = 0; c < comps.length(); c = c + 1 {
    let comp = comps[c]
    for k = 0; k < comp.length(); k = k + 1 {
      ids[comp[k]] = c
    }
  }
  ids
}
