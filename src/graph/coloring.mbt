///|
/// Graph vertex coloring (greedy heuristics).
///
/// A proper coloring assigns each vertex a color such that no two adjacent
/// vertices share a color. These greedy algorithms run on the *undirected*
/// view of the input graph (each directed edge u->v is treated as an
/// undirected edge between u and v).
///
/// Both return a `colors` array where `colors[i]` is the color of vertex i
/// (colors start at 0). `chromatic_number` reports how many colors were used.

// Build the undirected adjacency view of the graph (deduplicated).
fn build_undirected(g : Graph[Int, Int]) -> Array[Array[Int]] {
  let n = g.node_count()
  let adj : Array[Array[Int]] = []
  for i = 0; i < n; i = i + 1 {
    adj.push([])
  }
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      let v = g.get_edge(out[k]).to
      if !contains(adj[u], v) {
        adj[u].push(v)
      }
      if !contains(adj[v], u) {
        adj[v].push(u)
      }
    }
  }
  adj
}

///|
fn contains(arr : Array[Int], x : Int) -> Bool {
  for i = 0; i < arr.length(); i = i + 1 {
    if arr[i] == x {
      return true
    }
  }
  false
}

///|
/// Welsh-Powell coloring: vertices are colored in order of descending degree
/// (highest-degree first), each receiving the smallest color not used by an
/// already-colored neighbor. Simple and fast; a strong practical heuristic.
pub fn graph_coloring_welsh_powell(g : Graph[Int, Int]) -> Array[Int] {
  let n = g.node_count()
  let adj = build_undirected(g)
  let color : Array[Int] = Array::make(n, -1)

  // Order vertices by descending degree (insertion sort).
  let order : Array[Int] = []
  for i = 0; i < n; i = i + 1 {
    order.push(i)
  }
  for i = 1; i < n; i = i + 1 {
    let x = order[i]
    let xd = adj[x].length()
    let mut j = i - 1
    while j >= 0 {
      if adj[order[j]].length() < xd {
        order[j + 1] = order[j]
        j = j - 1
      } else {
        break
      }
    }
    order[j + 1] = x
  }

  for i = 0; i < n; i = i + 1 {
    let u = order[i]
    let used : Array[Bool] = Array::make(n, false)
    let nb = adj[u]
    for k = 0; k < nb.length(); k = k + 1 {
      let c = color[nb[k]]
      if c != -1 {
        used[c] = true
      }
    }
    let mut c = 0
    while used[c] {
      c = c + 1
    }
    color[u] = c
  }
  color
}

///|
/// DSatur coloring: repeatedly colors the uncolored vertex with the highest
/// *saturation degree* (number of distinct colors already present among its
/// neighbors), breaking ties by largest degree. DSatur typically uses fewer
/// colors than the basic Welsh-Powell heuristic.
pub fn graph_coloring_dsatur(g : Graph[Int, Int]) -> Array[Int] {
  let n = g.node_count()
  let adj = build_undirected(g)
  let color : Array[Int] = Array::make(n, -1)
  let sat : Array[Int] = Array::make(n, 0) // saturation degree per vertex
  let mut colored = 0

  while colored < n {
    // Select uncolored vertex with max saturation, tie-break by max degree.
    let mut best = -1
    let mut best_sat = -1
    let mut best_deg = -1
    for i = 0; i < n; i = i + 1 {
      if color[i] == -1 {
        if sat[i] > best_sat ||
          (sat[i] == best_sat && adj[i].length() > best_deg) {
          best = i
          best_sat = sat[i]
          best_deg = adj[i].length()
        }
      }
    }
    if best == -1 {
      break
    }

    // Assign the smallest color not used by a neighbor.
    let used : Array[Bool] = Array::make(n, false)
    let nb = adj[best]
    for k = 0; k < nb.length(); k = k + 1 {
      let c = color[nb[k]]
      if c != -1 {
        used[c] = true
      }
    }
    let mut c = 0
    while used[c] {
      c = c + 1
    }
    color[best] = c
    colored = colored + 1

    // Recompute saturation of still-uncolored neighbors.
    for k = 0; k < nb.length(); k = k + 1 {
      let v = nb[k]
      if color[v] == -1 {
        let ucol : Array[Bool] = Array::make(n, false)
        let vnb = adj[v]
        for m = 0; m < vnb.length(); m = m + 1 {
          let wc = color[vnb[m]]
          if wc != -1 {
            ucol[wc] = true
          }
        }
        let mut cnt = 0
        for m = 0; m < n; m = m + 1 {
          if ucol[m] {
            cnt = cnt + 1
          }
        }
        sat[v] = cnt
      }
    }
  }
  color
}

///|
/// Number of colors used by a coloring (max color index + 1).
pub fn chromatic_number(colors : Array[Int]) -> Int {
  let mut max_c = -1
  for i = 0; i < colors.length(); i = i + 1 {
    if colors[i] > max_c {
      max_c = colors[i]
    }
  }
  max_c + 1
}

///|
/// Verify that `colors` is a proper coloring of `g` (no adjacent vertices
/// share a color). Returns true if proper.
pub fn is_proper_coloring(g : Graph[Int, Int], colors : Array[Int]) -> Bool {
  let n = g.node_count()
  for u = 0; u < n; u = u + 1 {
    let out = g.out_edges(u)
    for k = 0; k < out.length(); k = k + 1 {
      let v = g.get_edge(out[k]).to
      if u != v && colors[u] == colors[v] {
        return false
      }
    }
  }
  true
}
