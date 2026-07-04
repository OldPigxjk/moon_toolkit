# moon_toolkit

MoonBit 通用图算法工具箱 — 15 种图论算法 + 基础数据结构。

## ✨ 差异化亮点（mooncakes.io 竞品无）

| 独有算法 | 复杂度 | 说明 |
|---------|--------|------|
| Prim / Kruskal MST | O(E log V), O(E α(V)) | 最小生成树 |
| Edmonds-Karp / Dinic | O(VE²), O(VE²) | 最大流 |
| Floyd-Warshall | O(V³) | 全源最短路 |
| Kuhn 匹配 | O(VE) | 二分图最大匹配 |
| Hierholzer | O(E) | 欧拉路/回路 |
| Tarjan AP&Bridge | O(V+E) | 割点 & 桥 |

## 特性

- 🚀 **泛型图结构** `Graph[N, E]`
- 📦 **基础 DS** — Union-Find、MinHeap
- 🔍 **遍历** — BFS、DFS
- 📏 **最短路** — Dijkstra、Bellman-Ford、Floyd-Warshall
- 🌲 **MST** — Prim、Kruskal
- 🔗 **高级** — 拓扑排序、Tarjan SCC、割点&桥
- 💧 **网络流** — Edmonds-Karp、Dinic
- 🔀 **匹配** — Kuhn 二分图匹配
- 🔄 **欧拉路** — Hierholzer

## 构建 & 测试

```bash
moon build   # 编译
moon test    # 50 tests, all pass ✅
```

## 许可证

Apache-2.0
