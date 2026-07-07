// examples/advanced_demo/advanced_demo.mbt
// 高级图算法使用示例 — MST、最大流、二分图匹配、欧拉路、图工具函数
//
// 本文件演示 moon_toolkit 中高级算法的实际调用方式。
// 所有示例使用 @graph.Graph::new() 创建图，通过 add_node/add_edge 构建拓扑。
// 跨包函数需以包别名限定调用（如 @shortest_path.prim_mst、@traverse.eulerian_trail）。
//
// 直接运行方式：
//   moon run examples/advanced_demo

///|
fn main {
  println("=== MoonBit 图算法工具箱 — 高级算法示例 ===\n")

  demo_prim_mst()
  demo_kruskal_mst()
  demo_max_flow()
  demo_bipartite_matching()
  demo_eulerian_path()
  demo_graph_utils()
}

///|
/// Prim 算法：最小生成树（基于二叉堆优化）
fn demo_prim_mst() -> Unit {
  println("--- Prim 最小生成树 ---")

  // 无向加权图（每条无向边存为两条方向相反的有向边）
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  // 无向边: 0-1(2), 0-3(6), 1-2(3), 1-3(8), 1-4(5), 2-4(7), 3-4(9)
  let _ = g.add_edge(0, 1, 2)
  let _ = g.add_edge(1, 0, 2)
  let _ = g.add_edge(0, 3, 6)
  let _ = g.add_edge(3, 0, 6)
  let _ = g.add_edge(1, 2, 3)
  let _ = g.add_edge(2, 1, 3)
  let _ = g.add_edge(1, 3, 8)
  let _ = g.add_edge(3, 1, 8)
  let _ = g.add_edge(1, 4, 5)
  let _ = g.add_edge(4, 1, 5)
  let _ = g.add_edge(2, 4, 7)
  let _ = g.add_edge(4, 2, 7)
  let _ = g.add_edge(3, 4, 9)
  let _ = g.add_edge(4, 3, 9)

  match @shortest_path.prim_mst(g) {
    Some(mst_edges) => {
      let mut total_weight = 0
      for i = 0; i < mst_edges.length(); i = i + 1 {
        let (u, v, w) = mst_edges[i]
        total_weight = total_weight + w
        println("  边 \{u} -- \{v} (权重 \{w})")
      }
      println("MST 总权重: \{total_weight}, 边数: \{mst_edges.length()}")
    }
    None => println("图不连通，不存在 MST!")
  }
  println("")
}

///|
/// Kruskal 算法：最小生成树（基于并查集 + 排序）
fn demo_kruskal_mst() -> Unit {
  println("--- Kruskal 最小生成树 ---")

  // 使用同一张无向图对比 Kruskal 结果
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 10)
  let _ = g.add_edge(1, 0, 10)
  let _ = g.add_edge(0, 2, 6)
  let _ = g.add_edge(2, 0, 6)
  let _ = g.add_edge(0, 3, 5)
  let _ = g.add_edge(3, 0, 5)
  let _ = g.add_edge(1, 2, 3)
  let _ = g.add_edge(2, 1, 3)
  let _ = g.add_edge(2, 3, 2)
  let _ = g.add_edge(3, 2, 2)

  match @shortest_path.kruskal_mst(g) {
    Some(mst_edges) => {
      let mut total_weight = 0
      for i = 0; i < mst_edges.length(); i = i + 1 {
        let (_, _, w) = mst_edges[i]
        total_weight = total_weight + w
      }
      println(
        "Kruskal MST 总权重: \{total_weight}, 边数: \{mst_edges.length()}",
      )
    }
    None => println("Kruskal: 不连通")
  }

  // 单节点测试
  let g_single : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g_single.add_node(42)
  match @shortest_path.kruskal_mst(g_single) {
    Some(edges) => println("单节点图 MST: \{edges.length()} 条边 ✓")
    None => println("错误！单节点应返回空 MST")
  }
  println("")
}

///|
/// Dinic / Edmonds-Karp 最大流算法
fn demo_max_flow() -> Unit {
  println("--- 最大流算法 ---")

  // 流网络经典示例: s=0, a=1, b=2, t=3
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0) // s (源点)
  let _ = g.add_node(0) // a
  let _ = g.add_node(0) // b
  let _ = g.add_node(0) // t (汇点)

  // 正向边容量
  let _ = g.add_edge(0, 1, 10) // s→a 容量10
  let _ = g.add_edge(0, 2, 10) // s→b 容量10
  let _ = g.add_edge(1, 2, 2) // a→b 容量2
  let _ = g.add_edge(1, 3, 7) // a→t 容量7
  let _ = g.add_edge(2, 3, 9) // b→t 容量9

  // Dinic 最大流
  let dinic_result = @shortest_path.dinic_max_flow(g, 0, 3)
  match dinic_result {
    Some(flow) => println("Dinic 最大流 (s→t): \{flow}")
    None => println("Dinic 计算失败")
  }

  // Edmonds-Karp 验证（结果应与 Dinic 一致）
  let ek_result = @shortest_path.edmonds_karp(g, 0, 3)
  match ek_result {
    Some(flow) => println("Edmonds-Karp 验证: \{flow} (应等于 Dinic)")
    None => println("Edmonds-Karp 计算失败")
  }

  // 无路径测试
  let g_empty : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g_empty.add_node(0)
  let _ = g_empty.add_node(0)
  let empty_flow = @shortest_path.dinic_max_flow(g_empty, 0, 1)
  match empty_flow {
    Some(f) => println("无路径图最大流: \{f} (期望 0)")
    None => println("无路径图: Dinic 计算失败")
  }
  println("")
}

///|
/// Kuhn 二分图最大匹配
fn demo_bipartite_matching() -> Unit {
  println("--- 二分图最大匹配 (Kuhn 算法) ---")

  // 左侧 3 个节点，右侧 4 个节点
  // 邻接表: 左侧 i → 可匹配的右侧节点列表
  let adj : Array[Array[Int]] = [
    [0, 2], // 左0 → 右0, 右2
    [0, 1], // 左1 → 右0, 右1
    [2], // 左2 → 右2
  ]

  let (match_r, count) = @traverse.kuhn_bipartite_match(adj, 3, 4)
  println("左侧 3 节点 × 右侧 4 节点")
  println("最大匹配数: \{count}")

  if count > 0 {
    let mut ms = "匹配情况: "
    for j = 0; j < match_r.length(); j = j + 1 {
      if match_r[j] >= 0 {
        ms = ms + "右\{j}<-左\{match_r[j]} "
      } else {
        ms = ms + "右\{j}-未匹配 "
      }
    }
    println(ms)
  }

  // 完全匹配测试
  let adj_full : Array[Array[Int]] = [
    [0, 1], // L0 → R0, R1
    [0, 1], // L1 → R0, R1
  ]
  let (_, cnt) = @traverse.kuhn_bipartite_match(adj_full, 2, 2)
  println("完全匹配测试 (2x2): 匹配数=\{cnt} (期望 2)")

  println("")
}

///|
/// Hierholzer 欧拉路/回路检测
fn demo_eulerian_path() -> Unit {
  println("--- 欧拉路/回路检测 (Hierholzer) ---")

  // 有向图欧拉回路示例（每个顶点入度=出度）
  let g1 : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g1.add_node(0)
  let _ = g1.add_node(0)
  let _ = g1.add_node(0)
  let _ = g1.add_node(0)

  let _ = g1.add_edge(0, 1, 1)
  let _ = g1.add_edge(1, 2, 1)
  let _ = g1.add_edge(2, 3, 1)
  let _ = g1.add_edge(3, 0, 1)
  let _ = g1.add_edge(0, 2, 1)
  let _ = g1.add_edge(2, 0, 1)

  match @traverse.eulerian_trail(g1) {
    Some(path) => {
      println("有向图欧拉回路: 长度=\{path.length()}, 节点序列:")
      let mut ps = "  ["
      for k = 0; k < path.length(); k = k + 1 {
        ps = ps + "\{path[k]}"
        if k < path.length() - 1 {
          ps = ps + " -> "
        }
      }
      println(ps + "]")
    }
    None => println("不存在欧拉路/回路!")
  }

  // 无向图（用双向边模拟）欧拉路
  let g2 : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g2.add_node(0)
  let _ = g2.add_node(0)
  let _ = g2.add_node(0)

  let _ = g2.add_edge(0, 1, 1)
  let _ = g2.add_edge(1, 0, 1)
  let _ = g2.add_edge(1, 2, 1)
  let _ = g2.add_edge(2, 1, 1)
  let _ = g2.add_edge(0, 2, 1)
  let _ = g2.add_edge(2, 0, 1)

  match @traverse.eulerian_trail(g2) {
    Some(path) => println("无向图欧拉路: 长度=\{path.length()} ✓")
    None => println("无向图: 不存在欧拉路")
  }

  // 含孤立点(无关联边)的图：孤立点不影响“覆盖所有边”的欧拉路判定
  let g_no : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g_no.add_node(0)
  let _ = g_no.add_node(0)
  let _ = g_no.add_node(0)
  let _ = g_no.add_edge(0, 1, 1)
  let _ = g_no.add_edge(1, 0, 1)
  // 节点 2 孤立(无任何边)，但边 0->1,1->0 自身构成欧拉回路

  match @traverse.eulerian_trail(g_no) {
    Some(path) =>
      println(
        "含孤立点(无边)的图: 仍找到覆盖全部边的欧拉回路 长度=\{path.length()} ✓",
      )
    None => println("错误！边 0->1,1->0 应构成欧拉回路")
  }
  println("")
}

///|
/// Graph 工具函数演示：连通性、反转、度数等
fn demo_graph_utils() -> Unit {
  println("--- Graph 工具函数演示 ---")

  // 构建连通图
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_edge(0, 1, 1)
  let _ = g.add_edge(1, 2, 1)
  let _ = g.add_edge(2, 3, 1)
  let _ = g.add_edge(3, 0, 1)

  // 连通性检查
  println("连通图连通性: \{@traverse.is_connected(g)} (期望 true)")
  println("连通分量数: \{@traverse.component_count(g)} (期望 1)")

  // 度数信息
  println(
    "各节点出度: node0=\{g.degree(0)}, node1=\{g.degree(1)}, node2=\{g.degree(2)}",
  )
  println(
    "各节点入度: node0=\{g.in_degree(0)}, node1=\{g.in_degree(1)}, node2=\{g.in_degree(2)}",
  )

  // 安全访问器
  match g.node_data_safe(0) {
    Some(v) => println("安全访问 node_data(0): Some(\{v}) (期望 Some)")
    None => println("安全访问 node_data(0): None (期望 Some)")
  }
  match g.node_data_safe(99) {
    Some(v) => println("安全访问 node_data(99): Some(\{v})")
    None => println("安全访问 node_data(99): None (期望 None)")
  }

  println("原图边 0->1 存在? \{g.has_edge(0, 1)}")

  // 不连通图
  let g2 : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g2.add_node(0)
  let _ = g2.add_node(0)
  let _ = g2.add_node(0)
  println("\n不连通图 (3个孤立节点):")
  println("  连通性: \{@traverse.is_connected(g2)} (期望 false)")
  println("  分量数: \{@traverse.component_count(g2)} (期望 3)")

  println("")
}
