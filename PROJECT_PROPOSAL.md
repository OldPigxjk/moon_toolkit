# moon_toolkit 项目申报书

| 项目 | 内容 |
|------|------|
| 名称 | moon_toolkit：MoonBit 通用图算法工具箱 |
| 参赛者 | 徐健凯 |
| 联系方式 | 18688611879 |
| GitHub 仓库 | https://github.com/OldPigxjk/moon_toolkit |
| GitLink 仓库 | https://www.gitlink.org.cn/oldpig/moon_toolkit |
| 项目方向 | MoonBit 图算法库 / 算法教育工具 |
| 是否为原创 | 是 |

## 项目简介

moon_toolkit 是一个用 MoonBit 编写的通用图算法工具箱，提供从基础数据结构到高级图算法的完整实现，面向 MoonBit 学习者、算法竞赛准备者及需要将图算法嵌入实际项目的 MoonBit 开发者。所有算法均配套完整单元测试（188 项测试全部通过），可直接作为 MoonBit 算法教学实践材料或实际项目的基础组件使用。

## 核心功能范围

- 数据结构：泛型最小堆 MinHeap（push/pop/peek）、并查集 UnionFind（路径压缩 + 按秩合并）；
- 图模型：泛型邻接表 Graph[N, E]，支持有向/无向，提供 add_node/add_edge/neighbors/degree 接口；
- 图遍历：BFS、DFS、拓扑排序（Kahn + DFS 双实现）、Tarjan SCC、割点与桥检测、二分图最大匹配（Kuhn）、欧拉路/回路（Hierholzer）；
- 最短路：Dijkstra（非负权）、Bellman-Ford（支持负权及负环检测）、Floyd-Warshall（全源最短路）；
- 最小生成树：Prim（基于 MinHeap）、Kruskal（基于 UnionFind）；
- 网络最大流：Edmonds-Karp、Dinic（BFS 分层 + DFS 阻塞流）。

## 移植或参考说明

- 参考资料：Cormen et al. Introduction to Algorithms（CLRS）第 3 版；Tarjan 原始论文及 Wikipedia 伪代码；
- 实现方式：独立用 MoonBit 编写，未复制任何现有开源项目的源代码；
- 与 mooncakes.io 现有图算法项目（MoonGraph、moonpath）相比，本项目新增了 6 个竞品没有的算法（MST、最大流、Floyd-Warshall、二分图匹配、欧拉路、割点桥），具有独立贡献价值。
