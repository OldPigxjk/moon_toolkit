/// Classic data structures used as building blocks for graph algorithms:
///   - Fenwick tree (Binary Indexed Tree): O(log n) point update / prefix sum
///   - Segment tree: O(log n) point update / range sum (arbitrary size)

// ---------------------------------------------------------------------------
// Fenwick tree (Binary Indexed Tree)
// ---------------------------------------------------------------------------

/// Fenwick tree over 0-based indices, supporting point updates and prefix /
/// range sum queries in O(log n).
pub struct Fenwick {
  tree: Array[Int]
  n: Int
}

/// Create a Fenwick tree of size `n` (all zeros).
pub fn Fenwick::new(n: Int) -> Fenwick {
  { tree: Array::make(n + 1, 0), n: n }
}

/// Add `delta` to the element at 0-based index `idx`.
pub fn Fenwick::add(self: Fenwick, idx: Int, delta: Int) -> Unit {
  let mut i = idx + 1
  while i <= self.n {
    self.tree[i] = self.tree[i] + delta
    i = i + (i & (-i))
  }
}

/// Sum of elements in [0, idx] inclusive (empty range when idx < 0 returns 0).
pub fn Fenwick::prefix_sum(self: Fenwick, idx: Int) -> Int {
  if idx < 0 {
    return 0
  }
  let mut i = idx + 1
  let mut s = 0
  while i > 0 {
    s = s + self.tree[i]
    i = i - (i & (-i))
  }
  s
}

/// Sum of elements in [l, r] inclusive; returns 0 if l > r.
pub fn Fenwick::range_sum(self: Fenwick, l: Int, r: Int) -> Int {
  if l > r {
    return 0
  }
  self.prefix_sum(r) - self.prefix_sum(l - 1)
}

// ---------------------------------------------------------------------------
// Segment tree (recursive, arbitrary size)
// ---------------------------------------------------------------------------

fn seg_build(t: Array[Int], a: Array[Int], node: Int, lo: Int, hi: Int) -> Unit {
  if lo == hi {
    t[node] = a[lo]
  } else {
    let mid = lo + (hi - lo) / 2
    seg_build(t, a, 2 * node, lo, mid)
    seg_build(t, a, 2 * node + 1, mid + 1, hi)
    t[node] = t[2 * node] + t[2 * node + 1]
  }
}

fn seg_update(
  t: Array[Int],
  node: Int,
  lo: Int,
  hi: Int,
  idx: Int,
  value: Int,
) -> Unit {
  if lo == hi {
    t[node] = value
  } else {
    let mid = lo + (hi - lo) / 2
    if idx <= mid {
      seg_update(t, 2 * node, lo, mid, idx, value)
    } else {
      seg_update(t, 2 * node + 1, mid + 1, hi, idx, value)
    }
    t[node] = t[2 * node] + t[2 * node + 1]
  }
}

fn seg_query(
  t: Array[Int],
  node: Int,
  lo: Int,
  hi: Int,
  ql: Int,
  qr: Int,
) -> Int {
  if ql > hi || qr < lo {
    return 0
  }
  if ql <= lo && hi <= qr {
    return t[node]
  }
  let mid = lo + (hi - lo) / 2
  let left = seg_query(t, 2 * node, lo, mid, ql, qr)
  let right = seg_query(t, 2 * node + 1, mid + 1, hi, ql, qr)
  left + right
}

/// Segment tree for range sum and point updates. Internal size is 4*n.
pub struct SegTree {
  t: Array[Int]
  n: Int
}

/// Build a segment tree from an existing array.
pub fn SegTree::from_array(a: Array[Int]) -> SegTree {
  let n = a.length()
  let t = Array::make(4 * n, 0)
  if n > 0 {
    seg_build(t, a, 1, 0, n - 1)
  }
  { t: t, n: n }
}

/// Create an empty segment tree of size `n` (all zeros).
pub fn SegTree::new(n: Int) -> SegTree {
  SegTree::from_array(Array::make(n, 0))
}

/// Set the element at `idx` to `value`.
pub fn SegTree::set(self: SegTree, idx: Int, value: Int) -> Unit {
  if self.n > 0 {
    seg_update(self.t, 1, 0, self.n - 1, idx, value)
  }
}

/// Add `delta` to the element at `idx`.
pub fn SegTree::add(self: SegTree, idx: Int, delta: Int) -> Unit {
  let cur = SegTree::query(self, idx, idx)
  SegTree::set(self, idx, cur + delta)
}

/// Sum of elements in [l, r] inclusive; returns 0 if l > r or n == 0.
pub fn SegTree::query(self: SegTree, l: Int, r: Int) -> Int {
  if self.n == 0 || l > r {
    return 0
  }
  seg_query(self.t, 1, 0, self.n - 1, l, r)
}
