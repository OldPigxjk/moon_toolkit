# moon_toolkit 项目申报书

**1. 项目名称**：moon_toolkit —— MoonBit 通用图算法工具箱

**2. 项目简介**：用 MoonBit 编写的通用图算法库，提供从基础数据结构到高级图算法的完整、可测试原生实现，面向 MoonBit 学习者、算法竞赛准备者及需将图算法嵌入实际项目的开发者。

**3. 项目方向与适用场景**：MoonBit 基础数据结构与算法方向（章程附录一明确列出 "Graph 相关算法库"）；适用于算法教学、工程路径规划、依赖分析与网络建模。

**4. 拟实现的核心功能**：图遍历（BFS/DFS/拓扑/Kosaraju SCC/割点桥）、最短路（Dijkstra/Bellman-Ford/Floyd-Warshall/A*/Johnson/Yen）、最小生成树（Prim/Kruskal）、网络最大流（Edmonds-Karp/Dinic/最小费用最大流）、匹配（二分图 Kuhn/匈牙利指派）、欧拉路、2-SAT、传递闭包、LCA、图着色、中心性度量（PageRank/度中心性）、DOT 序列化、泛型 Graph 数据结构与 MinHeap/UnionFind 等基础设施。

**5. 是否原创/移植/参考**：原创实现。参考 CLRS（算法导论）与 Tarjan 原论文的公开伪代码，独立用 MoonBit 编写，未复制任何现有开源项目源码；与 mooncakes.io 现有 MoonGraph、moonpath 相比，独占 MST、最大流、Floyd-Warshall、二分图匹配、欧拉路、割点桥等能力。

**6. 移植说明**：本项目为原创，不适用；参考来源均为公开教材/论文伪代码，已在源码与文档中标注。

**7. GitHub 仓库链接**：https://github.com/OldPigxjk/moon_toolkit （45+ 有效 commits，远超过 10–20 要求，无空提交/无意义拆分）

**8. GitLink 仓库链接**：https://www.gitlink.org.cn/oldpig/moon_toolkit （与 GitHub 同步，默认分支均为 main）

附：已发布至 mooncakes.io（`moon add OldPigxjk/moon_toolkit`），采用 Apache-2.0 许可证，CI 覆盖 check/build/test，191 项单元测试全部通过，提供 4 个可运行示例（含真实场景依赖分析 + 可扩展性基准），并对最短路/最小生成树/最大流做了跨算法交叉验证。
