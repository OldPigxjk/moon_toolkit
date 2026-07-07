///|
pub fn prim_mst(g : @graph.Graph[Int, Int]) -> Array[(Int, Int, Int)]? {
  let n = g.node_count()
  if n == 0 {
    return None
  }

  let visited = Array::make(n, false)
  let mst_edges = []
  let mut heap : @ds.MinHeap[(Int, Int, Int)] = @ds.MinHeap::new()

  // Start from node 0
  visited[0] = true
  let out_edges = g.out_edges(0)
  for i = 0; i < out_edges.length(); i = i + 1 {
    let edge_id = out_edges[i]
    let weight = g.edge_weight(edge_id)
    let v = g.get_edge(edge_id).to
    heap = @ds.MinHeap::push(heap, (weight, 0, v), weight)
  }

  while mst_edges.length() < n - 1 && @ds.MinHeap::length(heap) > 0 {
    let (popped, new_heap) = @ds.MinHeap::pop(heap)
    heap = new_heap
    match popped {
      Some((priority, u, v)) => {
        if visited[v] {
          continue
        }

        visited[v] = true
        mst_edges.push((u, v, priority))

        let out_edges = g.out_edges(v)
        for i = 0; i < out_edges.length(); i = i + 1 {
          let edge_id = out_edges[i]
          let edge = g.get_edge(edge_id)
          if !visited[edge.to] {
            let weight = g.edge_weight(edge_id)
            heap = @ds.MinHeap::push(heap, (weight, v, edge.to), weight)
          }
        }
      }
      None => break
    }
  }

  if mst_edges.length() < n - 1 {
    None
  } else {
    Some(mst_edges)
  }
}
