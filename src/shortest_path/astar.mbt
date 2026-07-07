///|
/// A* (A-star) single-source shortest path search guided by a heuristic.
///
/// `heuristic(u)` must return a NON-NEGATIVE estimate of the remaining cost
/// from node `u` to `goal` that never overestimates the true cost
/// (an *admissible* heuristic). When the heuristic is admissible, the first
/// time `goal` is popped from the priority queue its recorded distance is
/// optimal. With `heuristic(_) = 0` A* degenerates to Dijkstra.
///
/// Returns (dist, pred) arrays using the same convention as `dijkstra`:
///   dist[v] = shortest distance from start to v (2147483647 = unreachable)
///   pred[v] = predecessor node on the shortest path (-1 = none / unreachable)
/// Reconstruct the actual node sequence with `reconstruct_path(pred, start, goal)`.
///
/// Edge weights must be non-negative (negative weights are skipped).
pub fn astar(
  g : @graph.Graph[Int, Int],
  start : Int,
  goal : Int,
  heuristic : (Int) -> Int,
) -> (Array[Int], Array[Int]) {
  let n = g.node_count()
  let dist = Array::make(n, 2147483647)
  let pred = Array::make(n, -1)

  if start < 0 || start >= n {
    return (dist, pred)
  }
  if goal < 0 || goal >= n {
    return (dist, pred)
  }

  dist[start] = 0
  pred[start] = start
  let heap = @ds.MinHeap::new()
  let heap = heap.push(start, heuristic(start))
  let mut h = heap

  while !h.is_empty() {
    let (opt_u, new_h) = h.pop()
    h = new_h
    match opt_u {
      Some(u) => {
        // Goal reached with optimal cost (admissible heuristic guarantee).
        if u == goal {
          break
        }
        let u_dist = dist[u]
        if u_dist == 2147483647 {
          continue
        }
        // Relax every outgoing edge (parallel edges handled: each considered
        // independently so the minimum weight is used).
        let out_e = g.out_edges(u)
        for j = 0; j < out_e.length(); j = j + 1 {
          let e = g.get_edge(out_e[j])
          let v = e.to
          let w = e.weight
          // A* (like Dijkstra) requires non-negative edge weights.
          if w < 0 {
            continue
          }
          let new_dist = u_dist + w
          if new_dist >= 0 && new_dist < dist[v] {
            dist[v] = new_dist
            pred[v] = u
            h = h.push(v, new_dist + heuristic(v))
          }
        }
      }
      None => break
    }
  }
  (dist, pred)
}
