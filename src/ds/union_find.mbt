/// Union-Find (Disjoint Set Union) data structure.
/// Used by Kruskal's MST algorithm and connectivity checks.
pub struct UnionFind {
  parent: Array[Int]
  rank: Array[Int]
}

/// Create a new UnionFind with `n` elements (0..n-1).
pub fn UnionFind::new(n: Int) -> UnionFind {
  let parent = []
  let rank = []
  for i = 0; i < n; i = i + 1 {
    parent.push(i)
    rank.push(0)
  }
  { parent, rank }
}

/// Find the representative (root) of the set containing `x`.
/// Uses path compression.
pub fn UnionFind::find(self: UnionFind, x: Int) -> Int {
  if self.parent[x] != x {
    self.parent[x] = UnionFind::find(self, self.parent[x])
  }
  self.parent[x]
}

/// Union the sets containing `x` and `y`.
/// Uses union by rank.
pub fn UnionFind::union_set(self: UnionFind, x: Int, y: Int) -> (Bool, UnionFind) {
  let rx = UnionFind::find(self, x)
  let ry = UnionFind::find(self, y)
  if rx == ry { return (false, self) }
  if self.rank[rx] < self.rank[ry] {
    self.parent[rx] = ry
  } else if self.rank[rx] > self.rank[ry] {
    self.parent[ry] = rx
  } else {
    self.parent[ry] = rx
    self.rank[rx] = self.rank[rx] + 1
  }
  (true, self)
}

/// Check whether `x` and `y` are in the same set.
pub fn UnionFind::connected(self: UnionFind, x: Int, y: Int) -> Bool {
  UnionFind::find(self, x) == UnionFind::find(self, y)
}
