///|
/// Dinic's maximum flow algorithm.
/// Uses BFS level graph + DFS blocking flow.
/// Time complexity: O(E * V^2), faster than Edmonds-Karp O(V * E^2).
pub fn dinic_max_flow(g : @graph.Graph[Int, Int], s : Int, t : Int) -> Int? {
  let n = g.node_count()
  if s == t || s < 0 || s >= n || t < 0 || t >= n {
    return None
  }

  // Step 1: declare all variables
  let d_to : Array[Int] = []
  let d_rev : Array[Int] = []
  let d_cap : Array[Int] = []
  let d_adj : Array[Array[Int]] = []
  for _i = 0; _i < n; _i = _i + 1 {
    d_adj.push([])
  }

  let d_level : Array[Int] = Array::make(n, -1)
  let d_iter : Array[Int] = Array::make(n, 0)
  let mut d_flow = 0

  // Step 2: define inner functions
  fn d_add_edge(fro : Int, tt : Int, c : Int) -> Unit {
    let ei_from = d_to.length()
    let ei_to = d_to.length() + 1
    d_to.push(tt)
    d_to.push(fro)
    d_rev.push(ei_to)
    d_rev.push(ei_from)
    d_cap.push(c)
    d_cap.push(0)
    d_adj[fro].push(ei_from)
    d_adj[tt].push(ei_to)
  }

  fn d_bfs() -> Bool {
    for i = 0; i < n; i = i + 1 {
      d_level[i] = -1
    }
    let q : Array[Int] = [s]
    d_level[s] = 0
    let mut head = 0
    while head < q.length() {
      let v = q[head]
      head = head + 1
      let ei_list = d_adj[v]
      for i = 0; i < ei_list.length(); i = i + 1 {
        let ei = ei_list[i]
        if d_cap[ei] > 0 && d_level[d_to[ei]] < 0 {
          d_level[d_to[ei]] = d_level[v] + 1
          q.push(d_to[ei])
        }
      }
    }
    d_level[t] >= 0
  }

  fn d_dfs(v : Int, f : Int) -> Int {
    if v == t {
      return f
    }
    let mut ii = d_iter[v]
    while ii < d_adj[v].length() {
      let ei = d_adj[v][ii]
      if d_cap[ei] > 0 && d_level[v] < d_level[d_to[ei]] {
        let ret = d_dfs(d_to[ei], if f < d_cap[ei] { f } else { d_cap[ei] })
        if ret > 0 {
          d_cap[ei] = d_cap[ei] - ret
          d_cap[d_rev[ei]] = d_cap[d_rev[ei]] + ret
          d_iter[v] = ii
          return ret
        }
      }
      ii = ii + 1
      d_iter[v] = ii
    }
    0
  }

  // Step 3: main logic (no new let declarations)
  // Build residual graph
  for u = 0; u < n; u = u + 1 {
    let out_e = g.out_edges(u)
    for j = 0; j < out_e.length(); j = j + 1 {
      let edge = g.get_edge(out_e[j])
      d_add_edge(u, edge.to, edge.weight)
    }
  }

  // Dinic main loop
  while d_bfs() {
    for i = 0; i < n; i = i + 1 {
      d_iter[i] = 0
    }
    while true {
      let pushed = d_dfs(s, 2147483647)
      if pushed <= 0 {
        break
      }
      d_flow = d_flow + pushed
    }
  }

  Some(d_flow)
}
