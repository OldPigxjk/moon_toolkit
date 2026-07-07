///|
/// Lazy Segment Tree supporting range addition and range sum queries.
/// Build O(n); each update / query is O(log n).
/// "Lazy" here refers to lazy propagation of pending range updates.
pub struct LazySegTree {
  sum : Array[Int]
  pending : Array[Int]
  n : Int
}

///|
fn lbuild(
  sum : Array[Int],
  a : Array[Int],
  node : Int,
  lo : Int,
  hi : Int,
) -> Unit {
  if lo == hi {
    sum[node] = a[lo]
  } else {
    let mid = lo + (hi - lo) / 2
    lbuild(sum, a, 2 * node, lo, mid)
    lbuild(sum, a, 2 * node + 1, mid + 1, hi)
    sum[node] = sum[2 * node] + sum[2 * node + 1]
  }
}

///|
fn lpush(
  sum : Array[Int],
  pending : Array[Int],
  node : Int,
  lo : Int,
  hi : Int,
) -> Unit {
  if pending[node] != 0 {
    if lo != hi {
      pending[2 * node] = pending[2 * node] + pending[node]
      pending[2 * node + 1] = pending[2 * node + 1] + pending[node]
    }
    sum[node] = sum[node] + pending[node] * (hi - lo + 1)
    pending[node] = 0
  }
}

///|
fn lupdate(
  sum : Array[Int],
  pending : Array[Int],
  node : Int,
  lo : Int,
  hi : Int,
  ql : Int,
  qr : Int,
  val : Int,
) -> Unit {
  lpush(sum, pending, node, lo, hi)
  if ql > hi || qr < lo {
    return
  }
  if ql <= lo && hi <= qr {
    pending[node] = pending[node] + val
    lpush(sum, pending, node, lo, hi)
    return
  }
  let mid = lo + (hi - lo) / 2
  lupdate(sum, pending, 2 * node, lo, mid, ql, qr, val)
  lupdate(sum, pending, 2 * node + 1, mid + 1, hi, ql, qr, val)
  sum[node] = sum[2 * node] + sum[2 * node + 1]
}

///|
fn lquery(
  sum : Array[Int],
  pending : Array[Int],
  node : Int,
  lo : Int,
  hi : Int,
  ql : Int,
  qr : Int,
) -> Int {
  lpush(sum, pending, node, lo, hi)
  if ql > hi || qr < lo {
    return 0
  }
  if ql <= lo && hi <= qr {
    return sum[node]
  }
  let mid = lo + (hi - lo) / 2
  let left = lquery(sum, pending, 2 * node, lo, mid, ql, qr)
  let right = lquery(sum, pending, 2 * node + 1, mid + 1, hi, ql, qr)
  left + right
}

///|
/// Build a lazy segment tree from an array.
pub fn LazySegTree::from_array(a : Array[Int]) -> LazySegTree {
  let n = a.length()
  let sum = Array::make(4 * n, 0)
  let pending = Array::make(4 * n, 0)
  if n > 0 {
    lbuild(sum, a, 1, 0, n - 1)
  }
  { sum, pending, n }
}

///|
/// Build an empty lazy segment tree of size `n` (all zeros).
pub fn LazySegTree::new(n : Int) -> LazySegTree {
  LazySegTree::from_array(Array::make(n, 0))
}

///|
/// Add `val` to every element in the closed interval [l, r].
pub fn LazySegTree::range_add(
  self : LazySegTree,
  l : Int,
  r : Int,
  val : Int,
) -> Unit {
  if self.n > 0 && l <= r {
    lupdate(self.sum, self.pending, 1, 0, self.n - 1, l, r, val)
  }
}

///|
/// Sum of elements in the closed interval [l, r]; 0 if l > r or n == 0.
pub fn LazySegTree::range_sum(self : LazySegTree, l : Int, r : Int) -> Int {
  if self.n == 0 || l > r {
    return 0
  }
  lquery(self.sum, self.pending, 1, 0, self.n - 1, l, r)
}
