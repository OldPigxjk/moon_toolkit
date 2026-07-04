/// Edmonds-Karp maximum flow algorithm.
/// Returns the maximum flow value from `source` to `sink`, or None if inputs are invalid.
/// Uses BFS to find augmenting paths and updates residual capacities.
///
/// Time complexity: O(V * E^2) where V = node count, E = edge count.

pub fn edmonds_karp(g : @graph.Graph[Int, Int], source : Int, sink : Int) -> Int? {
  let n = g.node_count()
  if source < 0 || source >= n || sink < 0 || sink >= n || source == sink {
    return None
  }

  // Build adjacency list and residual capacity matrix
  // cap[u][v] = residual capacity from u to v
  let cap : Array[Array[Int]] = Array::make(n, [])
  for i = 0; i < n; i = i + 1 {
    cap[i] = Array::make(n, 0)
  }

  // Initialize residual capacities from original graph edges
  let m = g.edge_count()
  for i = 0; i < m; i = i + 1 {
    let edge = g.get_edge(i)
    let w = g.edge_weight(i)
    cap[edge.from][edge.to] = cap[edge.from][edge.to] + w
  }

  let mut max_flow = 0

  // Main loop: find augmenting paths with BFS
  let mut continue_loop = true
  while continue_loop {
    continue_loop = false

    // BFS to find shortest augmenting path from source to sink
    let visited : Array[Bool] = Array::make(n, false)
    let parent : Array[Int] = Array::make(n, -1)
    let queue : Array[Int] = []
    visited[source] = true
    queue.push(source)

    let mut head = 0
    while head < queue.length() && !visited[sink] {
      let u = queue[head]
      head = head + 1
      for v = 0; v < n; v = v + 1 {
        if !visited[v] && cap[u][v] > 0 {
          visited[v] = true
          parent[v] = u
          if v == sink {
            break
          }
          queue.push(v)
        }
      }
    }

    // No augmenting path found
    if !visited[sink] {
      continue
    }

    // Find bottleneck capacity along the path
    let mut bottleneck = 2147483647
    let mut v = sink
    while v != source {
      let u = parent[v]
      if cap[u][v] < bottleneck {
        bottleneck = cap[u][v]
      }
      v = u
    }

    // Update residual capacities
    v = sink
    while v != source {
      let u = parent[v]
      cap[u][v] = cap[u][v] - bottleneck
      cap[v][u] = cap[v][u] + bottleneck
      v = u
    }

    max_flow = max_flow + bottleneck
    continue_loop = true
  }

  Some(max_flow)
}
