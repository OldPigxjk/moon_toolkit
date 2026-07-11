# moon_toolkit

MoonBit 通用图算法工具箱 —— **30+ 经典图论与基础算法**原生实现，覆盖遍历、最短路、最小生成树、网络流、匹配、连通性、着色、中心性与高级数据结构。

## ✨ 特性

- 🧩 **泛型图结构** `Graph[N, E]`（节点 / 边带权，类型安全）
- 📦 **基础数据结构** —— 并查集、最小堆、树状数组、线段树、稀疏表（静态 RMQ）、懒标记线段树
- 🔍 **图遍历** —— BFS / DFS（含无权最短路、后序）
- 🔗 **连通性与特殊图** —— 强连通分量（Kosaraju / Tarjan）、割点 & 桥、环检测、欧拉路、二分图判定与着色、连通分量、传递闭包、LCA、2-SAT
- 📏 **最短路** —— Dijkstra（含路径还原）、Bellman-Ford、Floyd-Warshall、A*、Johnson 全源、Yen k 短路
- 🌲 **最小生成树** —— Prim、Kruskal
- 💧 **网络流** —— Edmonds-Karp、Dinic、最小费用最大流
- 🔀 **匹配** —— Kuhn 二分图最大匹配、Hungarian 指派问题
- 📊 **中心性** —— 度中心性、紧密中心性、介数中心性、特征向量中心性、PageRank
- 🎨 **图着色** —— Welsh-Powell、DSATUR、DOT 可视化导出

## 🎯 与 mooncakes.io 竞品的差异化

mooncakes.io 上现有图算法包（如 MoonGraph、moonpath）主要覆盖遍历 / 最短路 / 路径规划。本项目独有的 **最小生成树、网络流、全源最短路、二分图匹配、匈牙利指派、欧拉路、割点桥、强连通分量、2-SAT、传递闭包、LCA、图着色、中心性度量** 等形成互补而非重复。

## 🌐 English Overview

**moon_toolkit** is a native MoonBit implementation of **30+ classical graph algorithms and data structures** — covering traversal, shortest paths, minimum spanning trees, network flow, bipartite/matching, connectivity, coloring, centrality, and advanced data structures (Union-Find, heaps, segment trees, sparse tables).

- **Zero external dependencies**, pure MoonBit, fully tested (188 passing unit tests).
- **Ready-to-use examples**: `shortest_path_demo`, `advanced_demo`, plus a **real-world dependency analyzer** (`real_world_demo`) and a **scalability benchmark** (`benchmark_demo`).
- **Published** on [mooncakes.io](https://mooncakes.io/packages/OldPigxjk/moon_toolkit) as `OldPigxjk/moon_toolkit@0.1.2`, Apache-2.0 licensed.

Install: `moon add OldPigxjk/moon_toolkit`. Then call algorithms via qualified namespaces, e.g. `@shortest_path.dijkstra`, `@traverse.topo_kahn`, `@centrality.pagerank`.

## 📥 安装

```bash
moon add OldPigxjk/moon_toolkit      # 从 mooncakes.io 添加依赖（v0.1.2）
```

随后在消费方包的 `moon.pkg.json` 的 `import` 列表中声明所需子模块即可（模块会自动以末段命名空间引入，例如 `@graph` / `@shortest_path` / `@traverse`）：

```json
{
  "import": [
    "OldPigxjk/moon_toolkit/src/graph",
    "OldPigxjk/moon_toolkit/src/shortest_path",
    "OldPigxjk/moon_toolkit/src/traverse"
  ]
}
```

> 包已发布到 [mooncakes.io](https://mooncakes.io/packages/OldPigxjk/moon_toolkit)，可被公开检索与安装。

## 🚀 快速开始 / Quick Start

```moonbit
// 1) 建图（泛型邻接表，节点/边带权）
let g : @graph.Graph[Int, Int] = @graph.Graph::new()
let s = g.add_node(0)   // 源点
let a = g.add_node(0)
let t = g.add_node(0)   // 汇点
let _ = g.add_edge(s, a, 4)
let _ = g.add_edge(a, t, 3)

// 2) 跑算法（跨包以 @包名 限定调用）
let (dist, pred) = @shortest_path.dijkstra(g, s)
println("s->t 最短距离: \{dist[t]}")                // 7
let path = @shortest_path.reconstruct_path(pred, s, t)
println("路径: \{path}")                             // [0, 1, 2]

// 3) 其他算法同样开箱即用
let _ = @traverse.topo_kahn(g)                       // 拓扑排序
let _ = @centrality.pagerank(g, 0.85, 100, 1e-6)    // PageRank
```

## 🛠 构建 & 测试

```bash
moon build                     # 编译（库 + 示例）
moon test --deny-warn          # 188 项单元测试，全部通过 ✅
moon fmt --check               # 格式检查
moon check --deny-warn         # 0 警告 · 0 错误
moon run examples/shortest_path_demo   # 最短路径示例
moon run examples/advanced_demo         # 高级算法示例（MST/最大流/匹配/欧拉路）
moon run examples/real_world_demo      # 真实场景：软件包依赖分析（环检测+构建序+重要性）
moon run examples/benchmark_demo       # 性能基准：不同规模图上的可扩展性
```

GitHub Actions CI 已包含 `moon check` / `moon fmt --check` / `moon info` / `moon test` 四个过程（均带 `--deny-warn`）。

## 📐 代码规模

| 指标 | 数值 |
|------|------|
| 核心算法 / 数据结构 | 30+ |
| 源文件（`.mbt`，非测试） | 44 个 |
| 测试文件（`*_test.mbt`） | 42 个 |
| 可运行示例 | 4 个（含真实场景 + 性能基准） |
| MoonBit 代码总行数 | 7074 行（库 4120 + 测试 2954） |
| 单元测试 | 188 项，**全部通过** |
| 编译状态 | 0 警告 · 0 错误 |
| 许可证 | Apache-2.0 |

## 🔗 仓库

- GitHub：https://github.com/OldPigxjk/moon_toolkit
- GitLink：https://www.gitlink.org.cn/oldpig/moon_toolkit

## 📄 许可证

Apache-2.0
