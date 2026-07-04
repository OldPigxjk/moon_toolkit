// examples/shortest_path_demo.mbt
// 最短路径算法使用示例
//
// 运行方式：
//   1. 将此文件复制到 src/shortest_path/ 目录
//  2. moon run src/shortest_path/shortest_path_demo
//
// 或直接作为参考阅读

fn main {
  println("=== MoonBit 图算法工具箱 — 使用示例 ===\n")

  // ---- 示例1: Dijkstra 最短路径 ----
  demo_dijkstra()

  // ---- 示例2: Bellman-Ford（含负权边检测）----
  demo_bellman_ford()

  // ---- 示例3: Floyd-Warshall 全源最短路 ----
  demo_floyd_warshall()
}

fn demo_dijkstra() {
  println("--- Dijkstra 最短路径 ---")
  // 创建一个有向加权图（6 个节点）
  let mut g = graph::create_graph[Int, Int](6, true)

  // 添加边: from -> to, weight
  g.add_edge(0, 1, 10)
  g.add_edge(0, 4, 15)
  g.add_edge(1, 2, 15)
  g.add_edge(1, 3, 2)
  g.add_edge(2, 5, 5)
  g.add_edge(3, 2, 1)
  g.add_edge(3, 5, 12)
  g.add_edge(4, 5, 10)

  // 从节点 0 到所有其他节点的最短距离 + 路径
  match dijkstra::dijkstra(g, 0, 5) {
    Some(result) => {
      println("从节点 0 到节点 5 的最短距离: \{result.distance}")
      println("路径: \{result.path.to_string()}")
    }
    None => println("不可达!")
  }
  println("")
}

fn demo_bellman_ford() {
  println("--- Bellman-Ford 负权边支持 ---")

  // 创建含负权边的图
  let mut g = graph::create_graph[Int, Int](5, true)

  g.add_edge(0, 1, 6)
  g.add_edge(0, 2, 7)
  g.add_edge(1, 2, 8)
  g.add_edge(1, 3, 5)
  g.add_edge(1, 4, -4)   // 负权边！Dijkstra 无法处理
  g.add_edge(2, 3, -3)   // 负权边！
  g.add_edge(3, 4, 9)
  g.add_edge(4, 2, 7)    // 正环，不是负环
  g.add_edge(2, 1, -2)   // 负权回边

  match bellman_ford::bellman_ford(g, 0) {
    Ok(dist) => {
      println("从节点 0 出发，各点距离:")
      for i = 0; i < dist.length; i = i + 1 {
        println("  到节点\{i}: \{dist[i]}")
      }
    }
    Err(msg) => println("检测到负环: \{msg}!")
  }
  println("")
}

fn demo_floyd_warshall() {
  println("--- Floyd-Warshall 全源最短路径 ---")

  // 小规模图 (4 节点)
  let mut g = graph::create_graph[Int, Int](4, true)

  g.add_edge(0, 1, 5)
  g.add_edge(0, 3, 10)
  g.add_edge(1, 2, 3)
  g.add_edge(2, 3, 1)

  let (dist, nxt) = floyd_warshall::floyd_warshall(g)

  println("任意两点间最短距离矩阵:")
  print("     ")
  for j = 0; j < 4; j = j + 1 { print(" [\{j}] ") }
  println("")
  for i = 0; i < 4; i = i + 1 {
    print("[\{i}] ")
    for j = 0; j < 4; j = j + 1 {
      let d = if (dist[i][j] >= 2147483647 / 2) { " INF" } else { " \{dist[i][j]}" }
      print(d)
    }
    println("")
  }

  // 还原 0→3 的路径
  let path = floyd_warshall::fw_path(nxt, 0, 3)
  println("\n从节点 0 到节点 3 的路径: \{path.to_string()}")
}
