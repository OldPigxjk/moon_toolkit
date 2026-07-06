/// Generic directed graph with adjacency list representation.
/// Node data type N and edge weight/data type E are generic parameters.
/// Nodes are identified by integer ids (0-based, assigned in order of insertion).
/// Edges are also assigned unique integer ids.
///
/// # Example
/// ```
/// let g = Graph::new()
/// let n0 = g.add_node(10)
/// let n1 = g.add_node(20)
/// let e0 = g.add_edge(n0, n1, 5)
/// // g now has 2 nodes and 1 edge from n0 to n1 with weight 5
/// ```

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

// ---------------------------------------------------------------------------
// Construction
// ---------------------------------------------------------------------------

/// Create an empty graph with no nodes or edges.
pub fn[N, E] Graph::new() -> Graph[N, E] {
  { nodes: [], edges: [], adj: [] }
}

// ---------------------------------------------------------------------------
// Mutators
// ---------------------------------------------------------------------------

/// Add a node to the graph with the given data.
/// Returns the newly assigned node id (0-based sequential).
pub fn[N, E] Graph::add_node(self: Graph[N, E], data: N) -> Int {
  let id = self.nodes.length()
  self.nodes.push({ data, })
  self.adj.push([])
  id
}

/// Add a directed edge from `from` node to `to` node with given weight.
/// Returns the newly assigned edge id.
/// If `from` or `to` is not a valid node id, the behavior is undefined.
pub fn[N, E] Graph::add_edge(self: Graph[N, E], from: Int, to: Int, weight: E) -> Int {
  let id = self.edges.length()
  self.edges.push({ from, to, weight, })
  self.adj[from].push(id)
  id
}

// ---------------------------------------------------------------------------
// Queries — basic properties
// ---------------------------------------------------------------------------

/// Get the number of nodes in the graph.
pub fn[N, E] Graph::node_count(self: Graph[N, E]) -> Int {
  self.nodes.length()
}

/// Get the number of edges in the graph.
pub fn[N, E] Graph::edge_count(self: Graph[N, E]) -> Int {
  self.edges.length()
}

/// Check whether a node id is valid (within [0, node_count)).
pub fn[N, E] Graph::has_node(self: Graph[N, E], id: Int) -> Bool {
  id >= 0 && id < self.nodes.length()
}

/// Check whether an edge id is valid (within [0, edge_count)).
pub fn[N, E] Graph::has_edge_id(self: Graph[N, E], id: Int) -> Bool {
  id >= 0 && id < self.edges.length()
}

// ---------------------------------------------------------------------------
// Accessors — unsafe versions (undefined behavior on bad id)
// ---------------------------------------------------------------------------

/// Get node data by id.
/// If id is invalid, behavior is undefined (use node_data_safe for safe access).
pub fn[N, E] Graph::node_data(self: Graph[N, E], id: Int) -> N {
  self.nodes[id].data
}

/// Get edge weight by edge id.
/// If edge_id is invalid, behavior is undefined.
pub fn[N, E] Graph::edge_weight(self: Graph[N, E], edge_id: Int) -> E {
  self.edges[edge_id].weight
}

/// Get full edge data (from, to, weight) by edge id.
/// If edge_id is invalid, behavior is undefined.
pub fn[N, E] Graph::get_edge(self: Graph[N, E], edge_id: Int) -> EdgeData[E] {
  self.edges[edge_id]
}

// ---------------------------------------------------------------------------
// Accessors — safe versions (return Option)
// ---------------------------------------------------------------------------

/// Safely get node data. Returns None if id is invalid.
pub fn[N, E] Graph::node_data_safe(self: Graph[N, E], id: Int) -> N? {
  if id < 0 || id >= self.nodes.length() { None }
  else { Some(self.nodes[id].data) }
}

/// Safely get edge weight. Returns None if edge_id is invalid.
pub fn[N, E] Graph::edge_weight_safe(self: Graph[N, E], edge_id: Int) -> E? {
  if edge_id < 0 || edge_id >= self.edges.length() { None }
  else { Some(self.edges[edge_id].weight) }
}

/// Safely get edge data. Returns None if edge_id is invalid.
pub fn[N, E] Graph::get_edge_safe(self: Graph[N, E], edge_id: Int) -> EdgeData[E]? {
  if edge_id < 0 || edge_id >= self.edges.length() { None }
  else { Some(self.edges[edge_id]) }
}

// ---------------------------------------------------------------------------
// Traversal helpers
// ---------------------------------------------------------------------------

/// Get all neighbor node ids that are directly reachable via outgoing edges from `node`.
/// If node id is invalid, behavior is undefined.
pub fn[N, E] Graph::neighbors(self: Graph[N, E], node: Int) -> Array[Int] {
  let result : Array[Int] = []
  for edge_id in self.adj[node] {
    result.push(self.edges[edge_id].to)
  }
  result
}

/// Get all outgoing edge ids for a node.
/// If node id is invalid, behavior is undefined.
pub fn[N, E] Graph::out_edges(self: Graph[N, E], node: Int) -> Array[Int] {
  self.adj[node]
}

/// Check if the graph has a directed edge from `from` to `to`.
/// Returns false if either endpoint is invalid.
pub fn[N, E] Graph::has_edge(self: Graph[N, E], from: Int, to: Int) -> Bool {
  if from < 0 || from >= self.nodes.length() || to < 0 || to >= self.nodes.length() {
    return false
  }
  for edge_id in self.adj[from] {
    if self.edges[edge_id].to == to {
      return true
    }
  }
  false
}

// ---------------------------------------------------------------------------
// Graph utilities
// ---------------------------------------------------------------------------

// Note: Graph reversal requires mutable state or helper functions
// that are complex in MoonBit's value-semantics model.
// Use the traverse package's algorithms with a manually-constructed reversed graph if needed.

/// Compute the degree (out-degree) of a node.
/// Returns -1 if node id is invalid.
pub fn[N, E] Graph::degree(self: Graph[N, E], node: Int) -> Int {
  if node < 0 || node >= self.nodes.length() { -1 }
  else { self.out_edges(node).length() }
}

/// Compute in-degree of a node by scanning all edges.
/// O(E) time complexity.
/// Returns -1 if node id is invalid.
pub fn[N, E] Graph::in_degree(self: Graph[N, E], node: Int) -> Int {
  if node < 0 || node >= self.nodes.length() { return -1 }
  let mut cnt = 0
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[i].to == node {
      cnt = cnt + 1
    }
  }
  cnt
}
