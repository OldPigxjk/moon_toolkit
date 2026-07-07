// examples/shortest_path_demo/shortest_path_demo.mbt
// 最短路径算法使用示例 — Dijkstra、Bellman-Ford、Floyd-Warshall
//
// 本文件演示 moon_toolkit 中三个最短路径算法的实际调用方式。
// 所有示例使用 @graph.Graph::new() 创建图，通过 add_node/add_edge 构建拓扑。
// 跨包函数需以包别名限定调用（如 @shortest_path.dijkstra）。
//
// 直接运行方式：
//   moon run examples/shortest_path_demo

///|
fn main {
  println("=== MoonBit 图算法工具箱 — 最短路径示例 ===\n")

  demo_dijkstra()
  demo_bellman_ford()
  demo_floyd_warshall()
}

///|
/// Dijkstra 算法：非负权图单源最短路径
fn demo_dijkstra() -> Unit {
  println("--- Dijkstra 非负权最短路径 ---")

  // 构建有向加权图（6 个节点）
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0) // 节点 0
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  // 添加边: from -> to, weight
  let _ = g.add_edge(0, 1, 10)
  let _ = g.add_edge(0, 4, 15)
  let _ = g.add_edge(1, 2, 15)
  let _ = g.add_edge(1, 3, 2)
  let _ = g.add_edge(2, 5, 5)
  let _ = g.add_edge(3, 2, 1)
  let _ = g.add_edge(3, 5, 12)
  let _ = g.add_edge(4, 5, 10)

  // 运行 Dijkstra，获取距离数组和前驱数组
  let (dist, pred) = @shortest_path.dijkstra(g, 0)

  println("从节点 0 到各节点的最短距离:")
  for i = 0; i < g.node_count(); i = i + 1 {
    if dist[i] == 2147483647 {
      println("  节点 \{i}: 不可达")
    } else {
      println("  节点 \{i}: 距离=\{dist[i]}")
      // 还原从节点 0 到节点 i 的路径
      let path = @shortest_path.reconstruct_path(pred, 0, i)
      if path.length() > 0 {
        let mut ps = "    路径: "
        for k = 0; k < path.length(); k = k + 1 {
          ps = ps + "\{path[k]}"
          if k < path.length() - 1 {
            ps = ps + " -> "
          }
        }
        println(ps)
      }
    }
  }

  // 特殊情况：起点等于终点
  let same_path = @traverse.bfs_shortest_path(g, 3, 3)
  println("\n起点==终点测试 (3->3): 路径长度 = \{same_path.length()}")

  println("")
}

///|
/// Bellman-Ford 算法：支持负权边，可检测负环
fn demo_bellman_ford() -> Unit {
  println("--- Bellman-Ford 负权边支持与负环检测 ---")

  // 构建含负权边的图
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 6)
  let _ = g.add_edge(0, 2, 7)
  let _ = g.add_edge(1, 2, 8)
  let _ = g.add_edge(1, 3, 5)
  let _ = g.add_edge(1, 4, -4) // 负权边！Dijkstra 无法处理
  let _ = g.add_edge(2, 3, -3) // 负权边！
  let _ = g.add_edge(3, 4, 9)
  let _ = g.add_edge(4, 2, 7) // 正环，不是负环

  let result = @shortest_path.bellman_ford(g, 0)
  match result {
    Some((dist, _pred)) => {
      println("从节点 0 出发（无负环），各点距离:")
      for i = 0; i < g.node_count(); i = i + 1 {
        if dist[i] == 2147483647 {
          println("  节点 \{i}: 不可达")
        } else {
          println("  节点 \{i}: \{dist[i]}")
        }
      }
    }
    None => println("检测到负环！无法计算最短路径。")
  }

  // 测试含负环的图
  println("\n负环检测测试:")
  let g2 : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g2.add_node(0)
  let _ = g2.add_node(0)

  let _ = g2.add_edge(0, 1, 1)
  let _ = g2.add_edge(1, 0, -2) // 总和为 -1，构成负环！

  let result2 = @shortest_path.bellman_ford(g2, 0)
  match result2 {
    Some(_) => println("  错误！应该检测到负环")
    None => println("  正确检测到负环 ✓")
  }

  println("")
}

///|
/// Floyd-Warshall 算法：全源最短路 + 路径还原
fn demo_floyd_warshall() -> Unit {
  println("--- Floyd-Warshall 全源最短路径 ---")

  // 小规模有向加权图 (4 节点)
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)
  let _ = g.add_node(0)

  let _ = g.add_edge(0, 1, 5)
  let _ = g.add_edge(0, 3, 10)
  let _ = g.add_edge(1, 2, 3)
  let _ = g.add_edge(2, 3, 1)

  let (dist, nxt) = @shortest_path.floyd_warshall(g)

  println("任意两点间最短距离矩阵:")
  println("     [0] [1] [2] [3]")
  for i = 0; i < 4; i = i + 1 {
    let mut row_s = "[\{i}] "
    for j = 0; j < 4; j = j + 1 {
      let d = dist[i][j]
      row_s = row_s + (if d >= 2147483647 / 2 { " INF" } else { " \{d}" })
    }
    println(row_s)
  }

  // 使用 fw_path 还原 0→3 的最短路径
  let path = @shortest_path.fw_path(nxt, 0, 3)
  let mut ps = "\n从节点 0 到节点 3 的路径: ["
  for k = 0; k < path.length(); k = k + 1 {
    ps = ps + "\{path[k]}"
    if k < path.length() - 1 {
      ps = ps + " -> "
    }
  }
  println(ps + "]")
}
