# moon_toolkit 项目申报书

## 基本信息

- **项目名称**：moon_toolkit —— MoonBit 通用图算法工具箱
- **参赛者**：徐健凯
- **联系方式**：18688611879 / oldpigxjk@gmail.com
- **GitHub 仓库链接**：https://github.com/OldPigxjk/moon_toolkit （49 次有效提交）
- **GitLink 仓库链接**：https://www.gitlink.org.cn/oldpig/moon_toolkit （与 GitHub 同步，默认分支均为 main）
- **项目方向**：MoonBit 图算法基础库 / 数据结构与算法基础设施
- **是否为移植项目**：否（原创实现）

## 项目简介

moon_toolkit 是一套用 MoonBit 编写的通用图算法工具库，提供从基础图数据结构到高级图算法的完整原生实现。项目面向 MoonBit 学习者、算法竞赛准备者及需要在实际项目中嵌入图分析能力的开发者，涵盖最短路、最小生成树、网络流、匹配、遍历与连通性等经典算法领域，并提供真实场景依赖分析示例与可扩展性基准测试。所有算法均独立编写，参考 CLRS《算法导论》与 Tarjan 等经典论文的公开伪代码，未复制任何现有开源项目源码。

## 核心功能范围

- 提供泛型 Graph 数据模型，支持有向/无向/加权图构建、边增删、节点度查询、邻接矩阵转换；
- 实现图遍历算法：BFS 广度优先搜索、DFS 深度优先搜索、Kahn 拓扑排序；
- 实现连通性分析：Kosaraju 强连通分量分解、Tarjan 割点与桥检测；
- 实现单源最短路：Dijkstra（含堆优化）、Bellman-Ford（含负环检测）、A* 启发式搜索；
- 实现全源最短路：Floyd-Warshall、Johnson（稀疏图加速）、Yen K 短路枚举；
- 实现最小生成树：Prim（含堆优化）、Kruskal（含并查集）；
- 实现网络最大流：Edmonds-Karp（BFS 增广）、Dinic（分层网络+当前弧优化）、最小费用最大流；
- 实现匹配算法：二分图最大匹配 Kuhn 匈牙利算法；
- 实现欧拉路与欧拉回路：Hierholzer 算法；
- 提供辅助算法：2-SAT 可满足性判定、传递闭包 Warshal、最近公共祖先 LCA、图着色（贪心 Welsh-Powell）；
- 提供中心性度量：PageRank 迭代排名、度中心性计算；
- 提供 DOT 格式序列化输出（兼容 Graphviz 渲染）；
- 提供 MinHeap 二叉堆、UnionFind 并查集等基础数据结构；
- 提供不少于 191 个单元测试，覆盖全部核心路径与边界条件，并对最短路/最小生成树/最大流做了跨算法交叉验证；
- 提供可运行示例：软件包依赖分析器（真实 SCC 环检测+拓扑排序+PageRank 排序）与可扩展性性能基准（确定性 LCG 造图，无外部依赖）。
- 已发布至 mooncakes.io（`moon add OldPigxjk/moon_toolkit@0.1.2`），采用 Apache-2.0 许可证，CI 覆盖 check/build/test/fmt/info 三平台矩阵（ubuntu/macos/windows），持续集成通过。

## 移植或参考说明

本项目为**原创实现**，不涉及移植。

- **参考来源**：CLRS《算法导论》（Cormen et al.）、Tarjan 经典论文（SCC/割点桥）的公开伪代码
- **原创声明**：所有代码独立用 MoonBit 编写，未复制任何现有开源项目源码
- **生态差异化**：相比 mooncakes.io 现有 MoonGraph、moonpath、matrao 等图相关库，本库独占以下能力——最小生成树（Prim/Kruskal）、网络最大流（Edmonds-Karp/Dinic/费用流）、全源最短路（Floyd-Warshall/Johnson/Yen）、二分图匹配（Kuhn）、欧拉路（Hierholzer）、割点与桥（Tarjan）、中心性度量（PageRank）、DOT 序列化、交叉验证测试框架
