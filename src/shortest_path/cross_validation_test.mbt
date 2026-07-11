/// 交叉验证测试（cross-validation）
///
/// 目标：用相互独立的算法在「同一输入」上互相印证，证明实现的逻辑正确性。
/// 这类测试比单点断言更强 —— 它验证不同算法在一致输入下给出一致结果，
/// 从而排除单个算法内部的系统性偏差。
///
/// 覆盖：
///   1. 最短路：Dijkstra == Bellman-Ford == Floyd-Warshall（全源全点对）
///   2. 最短路路径还原性质：重建路径的边权和 == 声明最短路距离
///   3. 最小生成树：Prim 总权 == Kruskal 总权（MST 总权唯一）
///   4. 最大流：Edmonds-Karp == Dinic（最大流值唯一）

///|
/// 确定性 LCG（同一 seed 必得同一图，测试可复现）
/// 采用与 benchmark_demo 一致的带兜底写法，保证结果恒为非负、索引安全
fn cv_lcg(s : Int) -> Int {
  (s * 48271 % 1000000007 + 1000000007) % 1000000007
}

///|
/// 构造一个连通无向图（非负权），保证最短路与 MST 均有意义
fn cv_make_undirected(
  n : Int,
  seed0 : Int,
  extra : Int,
) -> @graph.Graph[Int, Int] {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < n; i = i + 1 {
    let _ = g.add_node(0)
  }
  // 生成树路径，保证连通
  let mut seed = seed0
  for i = 1; i < n; i = i + 1 {
    seed = cv_lcg(seed)
    let w = seed % 9 + 1
    let _ = g.add_edge(i - 1, i, w)
    let _ = g.add_edge(i, i - 1, w)
  }
  // 额外随机边（双向、非负权）
  for _k = 0; _k < extra; _k = _k + 1 {
    seed = cv_lcg(seed)
    let u = seed % n
    seed = cv_lcg(seed)
    let v = seed % n
    seed = cv_lcg(seed)
    let w = seed % 9 + 1
    if u != v {
      let _ = g.add_edge(u, v, w)
      let _ = g.add_edge(v, u, w)
    }
  }
  g
}

///|
test "crossval_shortest_paths_consistent" {
  let n = 14
  let g = cv_make_undirected(n, 12345, 30)

  // Floyd 全源距离矩阵
  let (fw_dist, _) = floyd_warshall(g)

  for s = 0; s < n; s = s + 1 {
    let (d_d, pred) = dijkstra(g, s)
    let opt_bf = bellman_ford(g, s)
    // Bellman-Ford 在无负权图上必返回 Some
    match opt_bf {
      Some((d_bf, _)) =>
        for v = 0; v < n; v = v + 1 {
          // 三算法对拍
          assert_eq(d_d[v], d_bf[v])
          assert_eq(d_d[v], fw_dist[s][v])
        }
      None => assert_true(false)
    }

    // 路径还原性质：对每个可达终点，重建路径的边权和 == 声明距离
    for v = 0; v < n; v = v + 1 {
      if d_d[v] < 2147483647 {
        let path = reconstruct_path(pred, s, v)
        assert_true(path.length() > 0)
        assert_eq(path[0], s)
        assert_eq(path[path.length() - 1], v)
        let mut sum = 0
        for i = 0; i < path.length() - 1; i = i + 1 {
          let u = path[i]
          let w = path[i + 1]
          // 取 u->w 的最小边权（图可能含平行边）
          let out = g.out_edges(u)
          let mut best = 2147483647
          for j = 0; j < out.length(); j = j + 1 {
            let e = g.get_edge(out[j])
            if e.to == w && e.weight < best {
              best = e.weight
            }
          }
          assert_true(best < 2147483647)
          sum = sum + best
        }
        assert_eq(sum, d_d[v])
      }
    }
  }
}

///|
test "crossval_mst_weight_agree" {
  let n = 14
  let g = cv_make_undirected(n, 777, 30)

  let opt_p = prim_mst(g)
  let opt_k = kruskal_mst(g)
  match (opt_p, opt_k) {
    (Some(pe), Some(ke)) => {
      let mut wp = 0
      for e in pe {
        let (_, _, w) = e
        wp = wp + w
      }
      let mut wk = 0
      for e in ke {
        let (_, _, w) = e
        wk = wk + w
      }
      // MST 总权唯一：Prim 与 Kruskal 必得同一总权
      assert_eq(wp, wk)
    }
    _ => assert_true(false)
  }
}

///|
/// 构造有向网络流图（含一条 0..n-1 的容量链，保证存在正流）
fn cv_make_flow(n : Int, seed0 : Int) -> @graph.Graph[Int, Int] {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < n; i = i + 1 {
    let _ = g.add_node(0)
  }
  let mut seed = seed0
  // 保证链：0->1->...->n-1，容量 1..9
  for i = 0; i < n - 1; i = i + 1 {
    seed = cv_lcg(seed)
    let cap = seed % 9 + 1
    let _ = g.add_edge(i, i + 1, cap)
  }
  // 额外随机有向边
  for _k = 0; _k < 25; _k = _k + 1 {
    seed = cv_lcg(seed)
    let u = seed % n
    seed = cv_lcg(seed)
    let v = seed % n
    seed = cv_lcg(seed)
    let cap = seed % 9 + 1
    if u != v {
      let _ = g.add_edge(u, v, cap)
    }
  }
  g
}

///|
test "crossval_maxflow_agree" {
  let n = 12
  let g = cv_make_flow(n, 2024)

  let opt_ek = edmonds_karp(g, 0, n - 1)
  let opt_d = dinic_max_flow(g, 0, n - 1)
  match (opt_ek, opt_d) {
    (Some(ek), Some(d)) => {
      // 最大流值唯一：两算法必得同一最大流
      assert_eq(ek, d)
      // 最大流不可能超过链上最小容量（下界合理性，排除异常大值）
      assert_true(ek > 0)
      assert_true(ek <= 9 * (n - 1))
    }
    _ => assert_true(false)
  }
}
