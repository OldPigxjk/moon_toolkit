// examples/advanced_demo.mbt
// 高级图算法使用示例：MST、最大流、二分图匹配、欧拉路
//
// 作为参考阅读，展示核心 API 调用方式

fn main {
  println("=== 高级算法示例 ===\n")

  demo_mst()
  demo_max_flow()
  demo_bipartite_matching()
  demo_eulerian_path()
}

fn demo_mst() {
  println("--- 最小生成树 (Prim) ---")
  // 无向加权图
  let mut g = graph::create_graph[Int, Int](5, false)

  g.add_edge(0, 1, 2)
  g.add_edge(0, 3, 6)
  g.add_edge(1, 2, 3)
  g.add_edge(1, 3, 8)
  g.add_edge(1, 4, 5)
  g.add_edge(2, 4, 7)
  g.add_edge(3, 4, 9)

  match prim::prim(g, 0) {
    Some(result) => {
      println("MST 总权重: \{result.total_weight}")
      println("MST 边数: \{result.edges.length}")
    }
    None => println("图不连通，不存在 MST!")
  }
  println("")
}

fn demo_max_flow() {
  println("--- 最大流 (Dinic) ---")
  // 流网络: 0=源点, 3=汇点
  let mut g = graph::create_graph[Int, Int](4, true)

  g.add_edge(0, 1, 10)   // s→a 容量10
  g.add_edge(0, 2, 10)   // s→b 容量10
  g.add_edge(1, 2, 2)    // a→b 容量2
  g.add_edge(1, 3, 7)    // a→t 容量7
  g.add_edge(2, 3, 9)    // b→t 容量9

  match dinic::dinic(g, 0, 3) {
    Some(flow) => println("从节点 0 到节点 3 的最大流: \{flow}")
    None => println("计算失败（可能存在反向边问题）")
  }

  // 对比 Edmonds-Karp 结果
  match edmonds_karp::edmonds_karp(g, 0, 3) {
    Some(flow) => println("Edmonds-Karp 验证结果: \{flow} （应与 Dinic 一致）")
    None => {}
  }
  println("")
}

fn demo_bipartite_matching() {
  println("--- 二分图最大匹配 ---")

  // 左侧 3 个节点，右侧 4 个节点
  // 邻接表: 左侧 i → 可匹配的右侧节点列表
  let adj: Array[Array[Int]] = [
    [1, 0, 1, 0],   // 左0 → 右0, 右2
    [1, 1, 0, 0],   // 左1 → 右0, 右1
    [0, 0, 1, 0],   // 左2 → 右2
  ]

  let (match_r, count) = bipartite::kuhn(adj, 3, 4)
  println("最大匹配数: \{count}")
  print("右侧匹配情况: ")
  for j = 0; j < match_r.length; j = j + 1 {
    if (match_r[j] >= 0) { print("右\{j}←左\{match_r[j]} ") }
  }
  println("")
  println("")
}

fn demo_eulerian_path() {
  println("--- 欧拉路/回路检测 ---")

  // 欧拉回路示例（每个顶点度数均为偶数）
  let mut g1 = graph::create_graph[Int, Int](4, true)
  g1.add_edge(0, 1, 1)
  g1.add_edge(1, 2, 1)
  g1.add_edge(2, 3, 1)
  g1.add_edge(3, 0, 1)
  g1.add_edge(0, 2, 1)
  g1.add_edge(2, 0, 1)

  match eulerian::find_eulerian(g1) {
    Some(path) => {
      println("欧拉路径长度: \{path.length}")
      println("欧拉路径: \{path.to_string()}")
    }
    None => println("不存在欧拉路/回路!")
  }

  // 无向图欧拉路
  let mut g2 = graph::create_graph[Int, Int](3, false)
  g2.add_edge(0, 1, 1)
  g2.add_edge(1, 2, 1)
  g2.add_edge(0, 2, 1)

  match eulerian::find_eulerian(g2) {
    Some(path) => println("无向图欧拉路: \{path.to_string()}")
    None => println("无向图: 不存在欧拉路")
  }
}
