# 使用示例

本目录包含 moon_toolkit 的可运行示例代码，展示各模块的核心 API 用法。

## 示例列表

| 目录 | 演示内容 |
|------|---------|
| `shortest_path_demo/` | Dijkstra、Bellman-Ford（含负环检测）、Floyd-Warshall（含路径还原） |
| `advanced_demo/` | Prim/Kruskal MST、Dinic/Edmonds-Karp 最大流、Kuhn 二分图匹配、Hierholzer 欧拉路、Graph 工具函数 |

## 直接运行

每个示例都是独立的可运行包（含 `moon.pkg.json`），无需复制，直接使用 `moon run`：

```bash
# 最短路径示例
moon run examples/shortest_path_demo

# 高级算法示例
moon run examples/advanced_demo
```

## 快速验证（库本身）

```bash
# 一键运行全部单元/边界测试
moon test --deny-warn    # 188 tests, all pass ✅

# 编译检查
moon check --deny-warn   # 0 errors, 0 warnings
```

## API 调用模式说明

所有示例遵循统一的图构建模式：

```
// 1. 创建空图
let g : @graph.Graph[Int, Int] = @graph.Graph::new()

// 2. 添加节点（返回节点 id）
let n0 = g.add_node(0)
let n1 = g.add_node(0)

// 3. 添加边 from -> to, weight（返回边 id）
let e0 = g.add_edge(n0, n1, 5)

// 4. 调用算法
let result = dijkstra(g, n0)
let mst = prim_mst(g)
let flow = dinic_max_flow(g, source, sink)
```
