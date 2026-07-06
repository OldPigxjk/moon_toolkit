/// Sparse Table for static Range Minimum Queries (RMQ).
/// Build O(n log n), query O(1). The underlying array is immutable
/// (no point updates); use a Segment Tree if updates are needed.

pub struct SparseTable {
  st: Array[Array[Int]]
  log: Array[Int]
  n: Int
}

/// Build a sparse table over `a` for range minimum queries.
pub fn SparseTable::from_array(a: Array[Int]) -> SparseTable {
  let n = a.length()
  let mut maxk = 0
  let mut pw = 1
  while pw <= n {
    maxk = maxk + 1
    pw = pw * 2
  }
  let st : Array[Array[Int]] = []
  for i = 0; i < maxk; i = i + 1 {
    st.push(Array::make(n, 2147483647))
  }
  for i = 0; i < n; i = i + 1 {
    st[0][i] = a[i]
  }
  let mut j = 1
  while (1 << j) <= n {
    for i = 0; i + (1 << j) <= n; i = i + 1 {
      let left = st[j - 1][i]
      let right = st[j - 1][i + (1 << (j - 1))]
      st[j][i] = if left < right { left } else { right }
    }
    j = j + 1
  }
  let log : Array[Int] = Array::make(n + 1, 0)
  for i = 2; i <= n; i = i + 1 {
    log[i] = log[i / 2] + 1
  }
  { st: st, log: log, n: n }
}

/// Query the minimum value in the closed interval [l, r].
/// Returns 2147483647 for an empty / out-of-range interval.
pub fn SparseTable::query_min(self: SparseTable, l: Int, r: Int) -> Int {
  if l > r || l < 0 || r >= self.n {
    return 2147483647
  }
  let k = self.log[r - l + 1]
  let left = self.st[k][l]
  let right = self.st[k][r - (1 << k) + 1]
  if left < right { left } else { right }
}
