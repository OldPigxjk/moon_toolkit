///|
/// Min-Cost Max-Flow (successive shortest paths, SPFA-based).
///
/// Computes a maximum flow from source `s` to sink `t`, and among all maximum
/// flows chooses the one with the minimum total cost. Each edge is described by
/// a tuple `(u, v, capacity, cost)`.
///
/// Costs may be negative, but the graph must NOT contain a negative-cost cycle.
/// Returns `(total_flow, total_cost)`.
///
/// Time complexity: O(F · E) in the common case (F = max flow value), where
/// SPFA finds the cheapest augmenting path each round.
priv struct MCMFEdge {
  to : Int
  cap : Int
  cost : Int
  flow : Int
  rev : Int
}

///|
/// Solve min-cost max-flow.
/// `edges` is a list of `(from, to, capacity, cost)` tuples.
/// `s` is the source node id, `t` is the sink node id.
/// Returns `(max_flow, min_cost)`.
pub fn min_cost_max_flow(
  n : Int,
  edges : Array[(Int, Int, Int, Int)],
  s : Int,
  t : Int,
) -> (Int, Int) {
  // Residual graph: graph[u] lists the indices of edges leaving u in `elist`.
  let graph : Array[Array[Int]] = []
  for i = 0; i < n; i = i + 1 {
    graph.push([])
  }
  let elist : Array[MCMFEdge] = []
  for i = 0; i < edges.length(); i = i + 1 {
    let (u, v, cap, cost) = edges[i]
    // forward edge
    let fwd = elist.length()
    let rev = fwd + 1
    elist.push({ to: v, cap, cost, flow: 0, rev })
    // reverse (residual) edge with 0 capacity and negated cost
    elist.push({ to: u, cap: 0, cost: -cost, flow: 0, rev: fwd })
    graph[u].push(fwd)
    graph[v].push(rev)
  }

  let mut total_flow = 0
  let mut total_cost = 0

  while true {
    let dist : Array[Int] = Array::make(n, 2147483647)
    let inq : Array[Bool] = Array::make(n, false)
    let prevv : Array[Int] = Array::make(n, -1)
    let preve : Array[Int] = Array::make(n, -1)
    let queue : Array[Int] = []
    let mut head = 0
    dist[s] = 0
    queue.push(s)
    inq[s] = true

    // SPFA: shortest path by cost in the residual graph
    while head < queue.length() {
      let u = queue[head]
      head = head + 1
      inq[u] = false
      let es = graph[u]
      for i = 0; i < es.length(); i = i + 1 {
        let eidx = es[i]
        let ed = elist[eidx]
        let rem = ed.cap - ed.flow
        if rem > 0 {
          let v = ed.to
          let nd = dist[u] + ed.cost
          if nd < dist[v] {
            dist[v] = nd
            prevv[v] = u
            preve[v] = eidx
            if !inq[v] {
              queue.push(v)
              inq[v] = true
            }
          }
        }
      }
    }

    if dist[t] == 2147483647 {
      break // no more augmenting paths
    }

    // Bottleneck capacity along the found path.
    let mut f = 2147483647
    let mut v = t
    while v != s {
      let eidx = preve[v]
      let ed = elist[eidx]
      let rem = ed.cap - ed.flow
      if rem < f {
        f = rem
      }
      v = prevv[v]
    }
    if f == 2147483647 {
      break
    }

    // Push flow f along the path; update forward and residual edges.
    v = t
    while v != s {
      let eidx = preve[v]
      let ed = elist[eidx]
      let ridx = ed.rev
      let red = elist[ridx]
      elist[eidx] = {
        to: ed.to,
        cap: ed.cap,
        cost: ed.cost,
        flow: ed.flow + f,
        rev: ed.rev,
      }
      elist[ridx] = {
        to: red.to,
        cap: red.cap,
        cost: red.cost,
        flow: red.flow - f,
        rev: red.rev,
      }
      v = prevv[v]
    }

    // Accumulate the actual cost of the augmented path.
    let mut path_cost = 0
    v = t
    while v != s {
      let eidx = preve[v]
      path_cost = path_cost + elist[eidx].cost
      v = prevv[v]
    }
    total_flow = total_flow + f
    total_cost = total_cost + f * path_cost
  }

  (total_flow, total_cost)
}
