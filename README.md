# moon_toolkit

MoonBit 通用图算法工具箱 —— **40+ 经典图论与基础算法**原生实现，覆盖遍历、最短路、最小生成树、网络流、匹配、连通性、着色、中心性与高级数据结构。

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

**moon_toolkit** is a native MoonBit implementation of **40+ classical graph algorithms and data structures** — covering traversal, shortest paths, minimum spanning trees, network flow, bipartite/matching, connectivity, coloring, centrality, and advanced data structures (Union-Find, heaps, segment trees, sparse tables).

- **Zero external dependencies**, pure MoonBit, fully tested (191 passing unit tests).
- **Ready-to-use examples**: `shortest_path_demo`, `advanced_demo`, plus a **real-world dependency analyzer** (`real_world_demo`) and a **scalability benchmark** (`benchmark_demo`).
- **Published** on [mooncakes.io](https://mooncakes.io/packages/OldPigxjk/moon_toolkit) as `OldPigxjk/moon_toolkit@0.1.2`, Apache-2.0 licensed.

Install: `moon add OldPigxjk/moon_toolkit`. Then call algorithms via qualified namespaces, e.g. `@shortest_path.dijkstra`, `@traverse.topo_kahn`, `@centrality.pagerank`.

## 🏗 架构与算法清单

### 包结构（依赖关系）

```mermaid
graph TD
  graph["graph · 泛型图 Graph[N,E] / 连通分量 / 二分图 / 着色 / LCA / 传递闭包 / 欧拉路 / DOT"]
  ds["ds · 并查集 / 最小堆 / 树状数组 / 线段树 / 懒标记线段树 / 稀疏表(RMQ)"]
  traverse["traverse · BFS/DFS / 拓扑 / Kosaraju·Tarjan SCC / 割点桥 / 环检测 / 二分图匹配 / 2-SAT"]
  shortest_path["shortest_path · Dijkstra / Bellman-Ford / Floyd / A* / Johnson / Yen / MST / 最大流"]
  flow["flow · 最小费用最大流"]
  matching["matching · 匈牙利指派"]
  centrality["centrality · 度/紧密/介数/特征向量中心性 / PageRank"]
  graph --> traverse
  graph --> shortest_path
  graph --> flow
  graph --> matching
  graph --> centrality
  ds --> traverse
  ds --> shortest_path
  ds --> flow
  ds --> matching
  ds --> centrality
```

### 算法清单（按子包）

| 子包 | 核心算法 / 数据结构 |
|------|----------------------|
| `graph` | 泛型 `Graph[N,E]`、连通分量、二分图判定与着色、Welsh-Powell / DSATUR 着色、LCA、传递闭包、欧拉路、DOT 序列化、边表构造 |
| `ds` | 并查集、最小堆、树状数组、线段树、懒标记线段树、稀疏表（静态 RMQ） |
| `traverse` | BFS / DFS（含无权最短路、后序）、拓扑排序（Kahn）、强连通分量（Kosaraju / Tarjan）、割点与桥、环检测、二分图最大匹配（Kuhn）、2-SAT |
| `shortest_path` | Dijkstra（含路径还原）、Bellman-Ford、Floyd-Warshall、A*、Johnson 全源、Yen k 短路、Prim、Kruskal、Edmonds-Karp、Dinic |
| `flow` | 最小费用最大流 |
| `matching` | 匈牙利指派（最大权匹配 / 最小代价） |
| `centrality` | 度中心性、紧密中心性、介数中心性、特征向量中心性、PageRank |

> 全部算法均通过单元测试，并对**最短路（Dijkstra / Bellman-Ford / Floyd-Warshall 三方对拍）、最小生成树（Prim / Kruskal 对拍）、最大流（Edmonds-Karp / Dinic 对拍）**做了跨算法交叉验证，确保逻辑一致、结果可复现。

## 📥 安装

```bash
moon add OldPigxjk/moon_toolkit      # 从 mooncakes.io 添加依赖（v0.1.2）
```

随后在消费方包的 `moon.pkg` 的 `import` 块中声明所需子模块即可（模块会自动以末段命名空间引入，例如 `@graph` / `@shortest_path` / `@traverse`）：

```moonbit
import {
  "OldPigxjk/moon_toolkit/src/graph",
  "OldPigxjk/moon_toolkit/src/shortest_path",
  "OldPigxjk/moon_toolkit/src/traverse",
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
moon test --deny-warn          # 191 项单元测试，全部通过 ✅
moon fmt --check               # 格式检查
moon check --deny-warn         # 0 警告 · 0 错误
moon run examples/shortest_path_demo   # 最短路径示例
moon run examples/advanced_demo         # 高级算法示例（MST/最大流/匹配/欧拉路）
moon run examples/real_world_demo      # 真实场景：软件包依赖分析（环检测+构建序+重要性）
moon run examples/benchmark_demo       # 性能基准：不同规模图上的可扩展性
```

GitHub Actions CI 已包含 **五个过程**（均带 `--deny-warn`）：`moon check` / `moon build` / `moon fmt --check` / `moon info` / `moon test`，完整覆盖章程验收标准5 要求的「检查、构建、测试」。

## 📐 代码规模

| 指标 | 数值 |
|------|------|
| 核心算法 / 数据结构 | 40+ |
| 源文件（`.mbt`，非测试） | 41 个（src 37 + examples 4） |
| 测试文件（`*_test.mbt`） | 43 个 |
| 可运行示例 | 4 个（含真实场景 + 性能基准） |
| MoonBit 代码总行数 | 7834 行（库 4702 + 测试 3132），落在章程 4~10k 参考区间 |
| 单元测试 | 191 项，**全部通过** |
| 编译状态 | 0 警告 · 0 错误 |
| 许可证 | Apache-2.0 |

## 🔗 仓库

- GitHub：https://github.com/OldPigxjk/moon_toolkit
- GitLink：https://www.gitlink.org.cn/oldpig/moon_toolkit

## 📚 参考与开源合规

- **原创实现**：本库所有算法均为独立用 MoonBit 编写，未复制任何现有开源项目源码。
- **参考来源**：算法思路参考 CLRS《算法导论》与 Tarjan 等经典论文的**公开伪代码**，已在源码注释与申报书中标注。
- **生态差异化**：相比 mooncakes.io 现有 MoonGraph、moonpath 等，本项目独占 MST、网络最大流、Floyd-Warshall、二分图匹配、匈牙利指派、欧拉路、割点桥等能力，非简单重复。
- **许可证**：采用 Apache-2.0（OSI 认证）；若后续移植/参考其他开源项目，将在此处补充原项目名、链接与许可证。

## 📄 许可证

Apache-2.0
