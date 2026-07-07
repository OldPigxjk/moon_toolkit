///|
/// Hungarian algorithm (Kuhn–Munkres) for the linear assignment problem.
///
/// Given an `n x n` cost matrix, finds a permutation `p` of the columns that
/// minimizes `sum_{i=0}^{n-1} cost[i][p[i]]`. Time complexity is O(n^3).
///
/// Returns `(assignment, total_cost)` where `assignment[i]` is the column
/// index assigned to row `i`. The matrix must be square; for rectangular
/// problems pad with a sufficiently large constant so dummy assignments are
/// never preferred.

// Core O(n^3) implementation on a square matrix. 1-indexed potentials are used
// internally (arrays of size n+1) to mirror the classic formulation.
fn hungarian_square(cost : Array[Array[Int]]) -> (Array[Int], Int) {
  let n = cost.length()
  if n == 0 {
    return ([], 0)
  }
  let u : Array[Int] = Array::make(n + 1, 0)
  let v : Array[Int] = Array::make(n + 1, 0)
  let p : Array[Int] = Array::make(n + 1, 0) // p[j] = row matched to column j
  let way : Array[Int] = Array::make(n + 1, 0)
  for i = 1; i <= n; i = i + 1 {
    p[0] = i
    let mut j0 = 0
    let minv : Array[Int] = Array::make(n + 1, 2147483647)
    let used : Array[Bool] = Array::make(n + 1, false)
    while true {
      used[j0] = true
      let i0 = p[j0]
      let mut delta = 2147483647
      let mut j1 = 0
      for j = 1; j <= n; j = j + 1 {
        if !used[j] {
          let cur = cost[i0 - 1][j - 1] - u[i0] - v[j]
          if cur < minv[j] {
            minv[j] = cur
            way[j] = j0
          }
          if minv[j] < delta {
            delta = minv[j]
            j1 = j
          }
        }
      }
      for j = 0; j <= n; j = j + 1 {
        if used[j] {
          u[p[j]] = u[p[j]] + delta
          v[j] = v[j] - delta
        } else {
          minv[j] = minv[j] - delta
        }
      }
      j0 = j1
      if p[j0] == 0 {
        break
      }
    }
    while true {
      let j1 = way[j0]
      p[j0] = p[j1]
      j0 = j1
      if j0 == 0 {
        break
      }
    }
  }
  let assignment : Array[Int] = Array::make(n, -1)
  for j = 1; j <= n; j = j + 1 {
    assignment[p[j] - 1] = j - 1
  }
  let mut total = 0
  for i = 0; i < n; i = i + 1 {
    total = total + cost[i][assignment[i]]
  }
  (assignment, total)
}

///|
/// Return both the assignment and its total cost for a square cost matrix.
pub fn hungarian_assignment(cost : Array[Array[Int]]) -> (Array[Int], Int) {
  hungarian_square(cost)
}

///|
/// Return only the minimum total cost for a square cost matrix.
pub fn hungarian_min_cost(cost : Array[Array[Int]]) -> Int {
  let (_assign, total) = hungarian_square(cost)
  total
}
