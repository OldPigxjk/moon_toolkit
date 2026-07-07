///|
/// Floyd-Warshall all-pairs shortest path algorithm.
/// Supports negative edges (no negative cycles). O(V^3).
pub fn floyd_warshall(
  g : @graph.Graph[Int, Int],
) -> (Array[Array[Int]], Array[Array[Int]]) {
  let n = g.node_count()

  let dist : Array[Array[Int]] = []
  let nxt : Array[Array[Int]] = []

  for i = 0; i < n; i = i + 1 {
    let row : Array[Int] = []
    let nrow : Array[Int] = []
    for j = 0; j < n; j = j + 1 {
      if i == j {
        row.push(0)
        nrow.push(j)
      } else {
        let w = fw_get_edge(g, i, j)
        row.push(w)
        if w < 2147483647 {
          nrow.push(j)
        } else {
          nrow.push(-1)
        }
      }
    }
    dist.push(row)
    nxt.push(nrow)
  }

  for k = 0; k < n; k = k + 1 {
    for i = 0; i < n; i = i + 1 {
      let dik = dist[i][k]
      if dik == 2147483647 {
        continue
      }
      for j = 0; j < n; j = j + 1 {
        let dkj = dist[k][j]
        if dkj != 2147483647 && dik + dkj < dist[i][j] {
          dist[i][j] = dik + dkj
          nxt[i][j] = nxt[i][k]
        }
      }
    }
  }

  (dist, nxt)
}

///|
fn fw_get_edge(g : @graph.Graph[Int, Int], from : Int, to : Int) -> Int {
  let out_e = g.out_edges(from)
  let mut best = 2147483647
  for i = 0; i < out_e.length(); i = i + 1 {
    let e = g.get_edge(out_e[i])
    if e.to == to && e.weight < best {
      best = e.weight
    }
  }
  best
}

///|
/// Reconstruct path from floyd_warshall next matrix.
pub fn fw_path(nxt : Array[Array[Int]], u : Int, v : Int) -> Array[Int] {
  let path : Array[Int] = []
  let n = nxt.length()
  if u < 0 || v < 0 || u >= n || v >= n {
    return path
  }
  if nxt[u][v] == -1 {
    return path
  }
  let mut cur = u
  while cur != v {
    path.push(cur)
    if nxt[cur][v] == -1 {
      return []
    }
    cur = nxt[cur][v]
    if path.length() > n {
      return []
    }
  }
  path.push(v)
  path
}
