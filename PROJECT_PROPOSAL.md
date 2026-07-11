# moon_toolkit 项目申报书

## 基本信息

| 项目 | 内容 |
|------|------|
| 名称 | moon_toolkit — MoonBit 通用图算法工具箱 |
| 参赛者 | 徐健凯 |
| 联系方式 | 18688611879 |
| GitHub | https://github.com/OldPigxjk/moon_toolkit |
| GitLink | https://gitlink.org.cn/oldpig/moon_toolkit |
| 方向 | 基础数据结构与算法 / 图算法库 |
| 原创性 | 原创，非移植 |

---

## 项目简介

MoonBit 生态通用图算法工具箱。提供泛型有向图 `Graph[N, E]` 及 **30+ 种**经典图论与基础算法的原生实现，覆盖遍历、最短路、最小生成树、网络流、匹配、连通性、着色、中心性与高级数据结构。配套完整单元测试（188 项，全部通过，0 警告 0 错误）。

mooncakes.io 上现有图算法包（如 MoonGraph、moonpath）主要覆盖遍历 / 最短路。本项目独有的最小生成树、网络流、全源最短路、二分图匹配、匈牙利指派、欧拉路、割点桥、强连通分量、2-SAT、传递闭包、LCA、图着色、中心性度量等能力形成互补而非重复。

## 核心功能

| 模块 | 算法 / 数据结构 |
|------|-----------------|
| 图结构 | 泛型有向图 Graph[N, E]、序列化、连通分量、传递闭包、LCA |
| 遍历 | BFS、DFS、拓扑排序、Kosaraju/Tarjan SCC |
| 最短路 | Dijkstra、Bellman-Ford、Floyd-Warshall、A*、Johnson 全源、Yen k 短路 |
| 最小生成树 | Prim、Kruskal |
| 网络流 | Edmonds-Karp、Dinic、最小费用最大流 |
| 匹配 | Kuhn 二分图匹配、Hungarian 指派 |
| 特殊图 | 欧拉路/欧拉环、割点 & 桥、环检测、二分图判定/着色、2-SAT、图着色（Welsh-Powell/DSATUR） |
| 中心性 | 度/紧密/介数/特征向量中心性、PageRank |
| 数据结构 | 并查集、最小堆、线段树（普通 + 懒标记）、稀疏表（RMQ） |

## 完成指标

| 指标 | 数值 |
|------|------|
| 核心算法 / 数据结构 | 37 项 |
| MoonBit 源码 | 4120 行（测试 2954 行，总计 7074 行） |
| 单元测试 | **188 项，全部通过** |
| 编译检查 | 0 警告 · 0 错误（`--deny-warn`） |
| CI | GitHub Actions 四步：check / fmt / info / test |
| 包发布 | mooncakes.io **v0.1.2**（`OldPigxjk/moon_toolkit`） |
| 许可证 | Apache-2.0（OSI 认可） |
| 提交记录 | **57 次**语义化提交，双仓库同步 |

## 原创说明

本项目为原创实现，非移植任何第三方开源项目。所有算法参考 CLRS《算法导论》等经典教材与 Wikipedia 技术文档，使用 MoonBit 泛型系统独立重写。核心设计：统一返回 `Option[T]` 避免 panic；全覆盖边界条件（平行边、负权、空图、单点、不可达、孤立点、非连通结构）；API 适配 MoonBit 包管理规范。
