/// Network/graph centrality measures.
///
/// Centrality quantifies the "importance" of a vertex. Three classic measures
/// are provided:
///   - degree centrality:     normalized number of incident edges
///   - closeness centrality:  inverse of the sum of shortest-path distances
///   - betweenness centrality: fraction of shortest paths that pass through a vertex
///
/// All measures treat the graph as UNWEIGHTED (each edge has unit length);
/// shortest paths are computed with BFS. Betweenness uses Brandes' algorithm.

// BFS distances from source `s`. Returns (distances, reachable_count) where
// `distances[v]` is the BFS distance (1 per edge) and `reachable_count` counts
// vertices other than `s` that are reachable.
fn bfs_distances(g: @graph.Graph[Int, Int], s: Int) -> (Array[Int], Int) {
  let n = g.node_count()
  let dist : Array[Int] = Array::make(n, 2147483647)
  dist[s] = 0
  let queue : Array[Int] = []
  let mut head = 0
  queue.push(s)
  let mut reach = 0
  while head < queue.length() {
    let u = queue[head]
    head = head + 1
    let nbrs = g.neighbors(u)
    for i = 0; i < nbrs.length(); i = i + 1 {
      let v = nbrs[i]
      if dist[v] == 2147483647 {
        dist[v] = dist[u] + 1
        reach = reach + 1
        queue.push(v)
      }
    }
  }
  (dist, reach)
}

/// Degree centrality of every vertex: (total degree) / (n - 1).
/// For directed graphs the total degree is in-degree + out-degree.
pub fn degree_centrality(g: @graph.Graph[Int, Int]) -> Array[Double] {
  let n = g.node_count()
  let res : Array[Double] = []
  let denom = if n > 1 {
    n - 1
  } else {
    1
  }
  for i = 0; i < n; i = i + 1 {
    let d = g.degree(i) + g.in_degree(i)
    res.push(d.to_double() / denom.to_double())
  }
  res
}

/// Closeness centrality of every vertex (normalized Wasserman-Faust variant):
///   C(u) = reach(u) / sum_dist(u) * reach(u) / (n - 1)
/// where reach(u) is the number of other vertices reachable from u.
/// A vertex that cannot reach any other returns 0.
pub fn closeness_centrality(g: @graph.Graph[Int, Int]) -> Array[Double] {
  let n = g.node_count()
  let res : Array[Double] = []
  for s = 0; s < n; s = s + 1 {
    let (dist, reach) = bfs_distances(g, s)
    let mut sum = 0
    for v = 0; v < n; v = v + 1 {
      if v != s {
        let dv = dist[v]
        if dv < 2147483647 {
          sum = sum + dv
        }
      }
    }
    if sum == 0 {
      res.push(0.0)
    } else {
      let r = reach.to_double()
      let cl = (r / sum.to_double()) * (r / (n - 1).to_double())
      res.push(cl)
    }
  }
  res
}

/// Betweenness centrality of every vertex (Brandes' algorithm, unweighted).
/// For each vertex v, C_B(v) estimates the fraction of all shortest paths
/// (between every ordered pair of vertices) that pass through v.
/// Note: computed for a DIRECTED graph; for undirected inputs divide by 2.
pub fn betweenness_centrality(g: @graph.Graph[Int, Int]) -> Array[Double] {
  let n = g.node_count()
  let bc : Array[Double] = Array::make(n, 0.0)

  for s = 0; s < n; s = s + 1 {
    // Brandes' BFS from s.
    let pred : Array[Array[Int]] = []
    for i = 0; i < n; i = i + 1 {
      pred.push([])
    }
    let sigma : Array[Int] = Array::make(n, 0)
    let dist : Array[Int] = Array::make(n, 2147483647)
    let stack : Array[Int] = []

    dist[s] = 0
    sigma[s] = 1
    let queue : Array[Int] = []
    let mut head = 0
    queue.push(s)

    while head < queue.length() {
      let v = queue[head]
      head = head + 1
      stack.push(v)
      let nbrs = g.neighbors(v)
      for i = 0; i < nbrs.length(); i = i + 1 {
        let w = nbrs[i]
        if dist[w] == 2147483647 {
          dist[w] = dist[v] + 1
          queue.push(w)
        }
        if dist[w] == dist[v] + 1 {
          sigma[w] = sigma[w] + sigma[v]
          pred[w].push(v)
        }
      }
    }

    let delta : Array[Double] = Array::make(n, 0.0)
    let mut sp = stack.length() - 1
    while sp >= 0 {
      let w = stack[sp]
      sp = sp - 1
      let pw = pred[w]
      for i = 0; i < pw.length(); i = i + 1 {
        let v = pw[i]
        let c = (sigma[v].to_double() / sigma[w].to_double()) * (1.0 + delta[w])
        delta[v] = delta[v] + c
      }
      if w != s {
        bc[w] = bc[w] + delta[w]
      }
    }
  }
  bc
}
