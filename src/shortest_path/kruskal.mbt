///|
pub fn kruskal_mst(g : @graph.Graph[Int, Int]) -> Array[(Int, Int, Int)]? {
  let n = g.node_count()
  if n == 0 {
    return None
  }

  // Collect all edges with their weights
  let edges = []
  let m = g.edge_count()
  for i = 0; i < m; i = i + 1 {
    let edge = g.get_edge(i)
    let weight = g.edge_weight(i)
    edges.push((weight, edge.from, edge.to))
  }

  // Sort edges by weight (using a simple bubble sort for now)
  for i = 0; i < edges.length() - 1; i = i + 1 {
    for j = 0; j < edges.length() - i - 1; j = j + 1 {
      let (w1, _, _) = edges[j]
      let (w2, _, _) = edges[j + 1]
      if w1 > w2 {
        let tmp = edges[j]
        edges[j] = edges[j + 1]
        edges[j + 1] = tmp
      }
    }
  }

  // Kruskal's algorithm with Union-Find
  let uf = @ds.UnionFind::new(n)
  let mst_edges = []

  let mut uf = uf
  for i = 0; i < edges.length(); i = i + 1 {
    if mst_edges.length() >= n - 1 {
      break
    }
    let (weight, u, v) = edges[i]
    if !@ds.UnionFind::connected(uf, u, v) {
      let (_, new_uf) = @ds.UnionFind::union_set(uf, u, v)
      uf = new_uf
      mst_edges.push((u, v, weight))
    }
  }

  if mst_edges.length() < n - 1 {
    None
  } else {
    Some(mst_edges)
  }
}
