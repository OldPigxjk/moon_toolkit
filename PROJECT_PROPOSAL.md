# moon_toolkit 项目申报书

## 基本信息

| 项目 | 内容 |
|------|------|
| 名称 | moon_toolkit — MoonBit 通用图算法工具箱 |
| 参赛者 | 徐健凯 |
| 联系方式 | 18688611879 |
| GitHub | https://github.com/OldPigxjk/moon_toolkit |
| GitLink | https://www.gitlink.org.cn/oldpig/moon_toolkit |
| 方向 | 基础数据结构与算法 / 图算法库 |
| 原创性 | 原创，非移植 |

## 项目简介

MoonBit 生态通用图算法工具箱。提供泛型有向图 `Graph[N, E]` 及 **30+ 种**经典图论与基础算法的原生实现，配套完整单元测试（188 项，全部通过，`moon check --deny-warn` / `moon test --deny-warn` 均为 0 警告 0 错误）。本轮新增大量边界测试（孤立点、非典型连通结构、不可达、负环、空图、单点等），GitHub Actions CI 覆盖 `moon check` / `moon fmt --check` / `moon info` / `moon test` 四个过程。

**与已有包的差异化**：mooncakes.io 上现有图算法包（MoonGraph、moonpath）主要覆盖遍历 / 最短路 / 路径规划。本项目独有 **最小生成树、网络流、全源最短路、二分图匹配、匈牙利指派、欧拉路、割点桥、强连通分量、2-SAT、传递闭包、LCA、图着色、中心性度量** 等核心能力，形成互补而非重复。

## 算法清单（30+ 项）

### 基础数据结构
- Union-Find 并查集（路径压缩 + 按秩合并）
- MinHeap 最小堆（泛型二叉堆）
- Fenwick 树状数组（前缀和 / 区间和）
- SegTree 线段树（单点修改 / 区间查询）
- SparseTable 稀疏表（静态区间最小值，O(1) 查询）
- LazySegTree 懒标记线段树（区间加 / 区间和）

### 图遍历
- BFS 广度优先遍历（含无权最短路径）
- DFS 深度优先遍历（含后序）

### 连通性与特殊图 ⭐竞品无
- Kosaraju 强连通分量 / Tarjan 强连通分量
- 割点 & 桥检测（Tarjan）
- 有向 / 无向环检测
- Hierholzer 欧拉路 / 回路
- Kuhn 二分图最大匹配 ⭐竞品无
- 2-SAT（基于 SCC） ⭐竞品无
- 连通分量 / 连通数 / 连通判定
- 传递闭包（Floyd-Warshall on reachability） ⭐竞品无
- 二分图判定与 2-着色
- LCA 最近公共祖先（二进制倍增） ⭐竞品无

### 最短路
- Dijkstra（含路径还原）
- Bellman-Ford（含负权处理）
- **Floyd-Warshall 全源最短路** ⭐竞品无
- A* 启发式搜索
- Johnson 全源最短路（含负权）
- Yen k 短路（无环）

### 最小生成树 ⭐竞品无
- Prim 算法
- Kruskal 算法（配合并查集）

### 网络流 ⭐竞品无
- Edmonds-Karp 最大流
- **Dinic 最大流**（O(VE²)）
- 最小费用最大流（SPFA 连续最短路）

### 匹配与指派 ⭐竞品无
- **Kuhn 二分图最大匹配**
- **Hungarian 匈牙利算法**（指派问题，O(n³)）

### 图着色与可视化 ⭐竞品无
- Welsh-Powell 贪心着色
- DSATUR 饱和度着色
- DOT 格式导出（Graphviz）

### 中心性度量 ⭐竞品无
- 度中心性 / 紧密中心性 / 介数中心性
- 特征向量中心性 / PageRank

## 完成情况

| 指标 | 数值 |
|------|------|
| 核心算法 / 数据结构 | 30+ 项 |
| 实现文件（`.mbt`，非测试） | 37 个 |
| 测试文件（`*_test.mbt`） | 42 个 |
| 单元测试 | 188 项，**全部通过** |
| MoonBit 代码总行数 | 6781 行（库 3827 + 测试 2954） |
| 编译状态 | 0 警告 · 0 错误 |
| 许可证 | Apache-2.0 |
| 包发布 | mooncakes.io 已发布（v0.1.2，公开可检索/安装） |

## 移植或参考说明

本项目为**原创实现**，非移植项目。所有算法均为经典图论算法的独立 MoonBit 原生实现，参考算法教科书（CLRS / 算法导论）的标准描述与伪代码，未直接复制任何第三方开源库代码。

| 参考来源 | 用途 | 说明 |
|---------|------|------|
| CLRS（算法导论）第3版 | 全部算法的理论基础和正确性证明 | 标准教材，无许可证限制 |
| Wikipedia 图算法条目 | 部分边界情况处理参考 | 无版权限制的技术文档 |

**与原项目/教材相比的差异**：
- 使用 MoonBit 泛型系统 `Graph[N, E]` 实现类型安全的图结构
- 统一返回 `Option[T]` / 显式结果，避免无谓 panic
- 全部算法配套完整单元测试，覆盖正常路径与边界条件（平行边、负权、空图、单点、不可达等）
- API 设计适配 MoonBit 包管理规范，可直接通过 `moon` 工具链构建测试，并已发布至 mooncakes.io
