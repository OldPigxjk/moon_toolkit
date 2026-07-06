# 使用示例

本目录包含 moon_toolkit 的可运行示例代码，展示各模块的核心 API 用法。

## 示例列表

| 文件 | 演示内容 |
|------|---------|
| `shortest_path_demo.mbt` | Dijkstra、Bellman-Ford（含负环检测）、Floyd-Warshall（含路径还原） |
| `advanced_demo.mbt` | Prim/Kruskal MST、Dinic/Edmonds-Karp 最大流、Kuhn 二分图匹配、Hierholzer 欧拉路、Graph 工具函数 |

## 运行方式

示例代码为 MoonBit 源文件（`.mbt`），需要复制到对应的 `src/` 子目录后运行：

```bash
# 1. 将示例复制到源码目录
cp examples/shortest_path_demo.mbt src/shortest_path/
cp examples/advanced_demo.mbt src/traverse/

# 2. 编译并运行
moon run src/shortest_path/shortest_path_demo
moon run src/traverse/advanced_demo
```

## 快速验证

```bash
# 一键测试所有算法
moon test    # 50+ tests, all pass ✅

# 编译检查
moon build   # Build OK (0 errors)
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
