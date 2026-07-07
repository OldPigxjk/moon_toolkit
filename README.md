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

## 🛠 构建 & 测试

```bash
moon build                     # 编译（库 + 示例）
moon test --deny-warn          # 188 项单元测试，全部通过 ✅
moon fmt --check               # 格式检查
moon check --deny-warn         # 0 警告 · 0 错误
moon run examples/shortest_path_demo   # 直接运行最短路径示例
moon run examples/advanced_demo         # 直接运行高级算法示例
```

GitHub Actions CI 已包含 `moon check` / `moon fmt --check` / `moon info` / `moon test` 四个过程（均带 `--deny-warn`）。

## 📐 代码规模

| 指标 | 数值 |
|------|------|
| 核心算法 / 数据结构 | 30+ |
| 源文件（`.mbt`，非测试） | 37 个 |
| 测试文件（`*_test.mbt`） | 42 个 |
| MoonBit 代码总行数 | 6781 行（库 3827 + 测试 2954） |
| 单元测试 | 188 项，**全部通过** |
| 编译状态 | 0 警告 · 0 错误 |
| 许可证 | Apache-2.0 |

## 📄 许可证

Apache-2.0
