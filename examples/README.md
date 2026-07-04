# 使用示例

本目录包含 moon_toolkit 的可运行示例代码，展示各模块的核心 API 用法。

## 示例列表

| 文件 | 演示内容 |
|------|---------|
| `shortest_path_demo.mbt` | Dijkstra、Bellman-Ford、Floyd-Warshall 最短路径 |
| `advanced_demo.mbt` | Prim/Kruskal MST、Dinic/Edmonds-Karp 最大流、Kuhn 二分图匹配、Hierholzer 欧拉路 |

## 运行方式

示例代码为 MoonBit 源文件（`.mbt`），需要复制到对应的 `src/` 子目录后运行：

```bash
# 1. 将示例复制到源码目录
cp examples/shortest_path_demo.mbt src/shortest_path/
cp examples/advanced_demo.mbt src/traverse/

# 2. 编译并运行
moon run src/shortest_path/shortest_path_demo
moon run src/traverse/advanced_demo

# 3. 或直接编译测试全部代码
moon build && moon test
```

## 快速验证

```bash
# 一键测试所有算法
moon test    # 应输出: 50 tests, all pass ✅

# 编译检查
moon build   # 应输出: Build OK (0 errors)
```
