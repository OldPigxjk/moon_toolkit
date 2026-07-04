/// Graph data structure for moon_toolkit.
/// A generic directed graph with node/edge storage backed by adjacency lists.

pub struct Graph[N, E] {
  nodes: Array[NodeData[N]]
  edges: Array[EdgeData[E]]
  adj: Array[Array[Int]]
}

pub struct NodeData[N] {
  data: N
}

pub struct EdgeData[E] {
  from: Int
  to: Int
  weight: E
}

/// Create an empty graph.
pub fn[N, E] Graph::new() -> Graph[N, E] {
  { nodes: [], edges: [], adj: [] }
}

/// Add a node to the graph. Returns the node id.
pub fn[N, E] Graph::add_node(self: Graph[N, E], data: N) -> Int {
  let id = self.nodes.length()
  self.nodes.push({ data, })
  self.adj.push([])
  id
}

/// Add a directed edge from `from` to `to` with given weight.
/// Returns the edge id.
pub fn[N, E] Graph::add_edge(self: Graph[N, E], from: Int, to: Int, weight: E) -> Int {
  let id = self.edges.length()
  self.edges.push({ from, to, weight, })
  self.adj[from].push(id)
  id
}

/// Get the number of nodes.
pub fn[N, E] Graph::node_count(self: Graph[N, E]) -> Int {
  self.nodes.length()
}

/// Get the number of edges.
pub fn[N, E] Graph::edge_count(self: Graph[N, E]) -> Int {
  self.edges.length()
}

/// Get node data by id.
pub fn[N, E] Graph::node_data(self: Graph[N, E], id: Int) -> N {
  self.nodes[id].data
}

/// Get edge weight by edge id.
pub fn[N, E] Graph::edge_weight(self: Graph[N, E], edge_id: Int) -> E {
  self.edges[edge_id].weight
}

/// Get edge by edge id.
pub fn[N, E] Graph::get_edge(self: Graph[N, E], edge_id: Int) -> EdgeData[E] {
  self.edges[edge_id]
}

/// Iterate over all neighbor node ids of a given node.
pub fn[N, E] Graph::neighbors(self: Graph[N, E], node: Int) -> Array[Int] {
  let result = []
  for edge_id in self.adj[node] {
    result.push(self.edges[edge_id].to)
  }
  result
}

/// Get all edge ids outgoing from a node.
pub fn[N, E] Graph::out_edges(self: Graph[N, E], node: Int) -> Array[Int] {
  self.adj[node]
}

/// Check if the graph has a directed edge from `from` to `to`.
pub fn[N, E] Graph::has_edge(self: Graph[N, E], from: Int, to: Int) -> Bool {
  for edge_id in self.adj[from] {
    if self.edges[edge_id].to == to {
      return true
    }
  }
  false
}
