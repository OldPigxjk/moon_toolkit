// examples/real_world_demo/real_world_demo.mbt
// 真实场景示例 —— 软件包依赖分析器 (Package Dependency Analyzer)
//
// 本示例把 moon_toolkit 当作一个"解决实际工程问题"的工具，而不是玩具：
// 给定一个软件项目的包依赖关系，自动完成三件工程师真正关心的事：
//   1) 依赖环检测   —— Kosaraju 强连通分量，找出会卡死构建的循环依赖
//   2) 安全构建顺序 —— 拓扑排序 (Kahn)，给出可并行/可串行的编译次序
//   3) 重要性排序   —— PageRank + 度中心性，找出"被依赖最多"的核心包
//
// 这展示了一个通用图算法库如何直接服务于软件工程场景，
// 也是区别于"纯教科书复刻"的差异化价值点。
//
// 直接运行：  moon run examples/real_world_demo

///|
/// 包名表（节点 id = 数组下标）
let names : Array[String] = [
  "core", "utils", "logging", "config", "cache", "db", "auth", "api", "ui", "net",
  "cli", "test",
]

///|
/// 依赖关系：每个元组 (包, 它依赖的包列表)
let deps : Array[(String, Array[String])] = [
  ("core", []),
  ("utils", ["core"]),
  ("logging", ["core"]),
  ("config", ["core"]),
  ("cache", ["core"]),
  ("db", ["core", "cache"]),
  ("auth", ["core", "db"]),
  ("api", ["core", "auth", "db"]),
  ("ui", ["core"]),
  ("net", ["core", "logging"]),
  ("cli", ["api", "net"]),
  ("test", ["api", "ui"]),
]

///|
/// 按包名查节点 id
fn id_of(name : String) -> Int {
  for i = 0; i < names.length(); i = i + 1 {
    if names[i] == name {
      return i
    }
  }
  0
}

///|
fn main {
  println("=== moon_toolkit 真实场景：软件包依赖分析器 ===\n")

  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < names.length(); i = i + 1 {
    let _ = g.add_node(0)
  }
  for i = 0; i < deps.length(); i = i + 1 {
    let (pkg, ds) = deps[i]
    let u = id_of(pkg)
    for j = 0; j < ds.length(); j = j + 1 {
      let v = id_of(ds[j])
      let _ = g.add_edge(u, v, 1)
    }
  }

  println(
    "项目规模：\{g.node_count()} 个包，\{g.edge_count()} 条依赖边\n",
  )

  analyze_cycles(g)
  analyze_build_order(g)
  analyze_importance(g)

  println("\n=== 对比演示：人为注入循环依赖会如何？ ===\n")
  demo_cycle_blocks_build()
}

///|
/// 1) 依赖环检测：用 Kosaraju 求 SCC，size>1 或自环即构成循环依赖
fn analyze_cycles(g : @graph.Graph[Int, Int]) -> Unit {
  println("--- 1. 循环依赖检测 (Kosaraju SCC) ---")
  let sccs = @traverse.kosaraju_scc(g)
  let mut cycle_count = 0
  for i = 0; i < sccs.length(); i = i + 1 {
    let comp = sccs[i]
    if comp.length() > 1 {
      cycle_count = cycle_count + 1
      let mut s = "  循环依赖环 #\{cycle_count}: "
      for k = 0; k < comp.length(); k = k + 1 {
        s = s + names[comp[k]]
        if k < comp.length() - 1 {
          s = s + " -> "
        }
      }
      println(s + " -> " + names[comp[0]])
    } else {
      let v = comp[0]
      if g.has_edge(v, v) {
        cycle_count = cycle_count + 1
        println("  自循环依赖: " + names[v] + " -> " + names[v])
      }
    }
  }
  if cycle_count == 0 {
    println("  ✓ 未检测到循环依赖，依赖图是健康的 DAG")
  }
  println("")
}

///|
/// 2) 安全构建顺序：拓扑排序 (Kahn)
fn analyze_build_order(g : @graph.Graph[Int, Int]) -> Unit {
  println("--- 2. 安全构建顺序 (拓扑排序 Kahn) ---")
  match @traverse.topo_kahn(g) {
    Some(order) => {
      let mut s = "  编译次序: "
      for i = 0; i < order.length(); i = i + 1 {
        s = s + names[order[i]]
        if i < order.length() - 1 {
          s = s + " -> "
        }
      }
      println(s)
      println("  (越靠前越底层，可优先并行编译)")
    }
    None => println("  ✗ 存在循环依赖，无法生成拓扑序")
  }
  println("")
}

///|
/// 3) 重要性排序：PageRank + 度中心性（谁被依赖得最多）
fn analyze_importance(g : @graph.Graph[Int, Int]) -> Unit {
  println("--- 3. 包重要性排序 (PageRank + 度中心性) ---")
  let pr = @centrality.pagerank(g, 0.85, 100, 0.000001)
  let dc = @centrality.degree_centrality(g)

  // 按 PageRank 降序选择排序
  let order : Array[Int] = []
  for i = 0; i < names.length(); i = i + 1 {
    order.push(i)
  }
  for i = 1; i < order.length(); i = i + 1 {
    let x = order[i]
    let mut j = i - 1
    while j >= 0 {
      if pr[order[j]] < pr[x] {
        order[j + 1] = order[j]
        j = j - 1
      } else {
        break
      }
    }
    order[j + 1] = x
  }

  println("  Top 包 (被依赖越多 PageRank 越高):")
  for i = 0; i < names.length() && i < 6; i = i + 1 {
    let idx = order[i]
    println(
      "    \{i + 1}. \{names[idx]}  PR=\{pr[idx]}  度中心性=\{dc[idx]}",
    )
  }
  println("")
}

///|
/// 注入循环依赖 a->b->c->a，证明环检测 + 拓扑排序能拦住它
fn demo_cycle_blocks_build() -> Unit {
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  let _ = g.add_node(0) // a
  let _ = g.add_node(0) // b
  let _ = g.add_node(0) // c
  let _ = g.add_edge(0, 1, 1) // a -> b
  let _ = g.add_edge(1, 2, 1) // b -> c
  let _ = g.add_edge(2, 0, 1) // c -> a (环!)

  let sccs = @traverse.kosaraju_scc(g)
  let mut found = false
  for i = 0; i < sccs.length(); i = i + 1 {
    if sccs[i].length() > 1 {
      found = true
      println(
        "  检测到循环依赖：a -> b -> c -> a (SCC 大小 \{sccs[i].length()})",
      )
    }
  }
  if !found {
    println("  (未检测到环，逻辑异常!)")
  }

  match @traverse.topo_kahn(g) {
    Some(_) => println("  ✗ 错误：有环却生成了拓扑序")
    None =>
      println(
        "  ✓ 拓扑排序正确拒绝：存在循环依赖，构建顺序无法计算",
      )
  }
}
