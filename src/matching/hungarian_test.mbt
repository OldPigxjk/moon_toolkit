///|
/// Test for the Hungarian assignment algorithm

// Verify `a` is a valid permutation of 0..n-1.
fn is_perm(a : Array[Int]) -> Bool {
  let n = a.length()
  let seen : Array[Bool] = Array::make(n, false)
  for i = 0; i < n; i = i + 1 {
    let x = a[i]
    if x < 0 || x >= n {
      return false
    }
    if seen[x] {
      return false
    }
    seen[x] = true
  }
  true
}

///|
test "hungarian_3x3_known" {
  // Optimal assignment: row0->col1, row1->col0, row2->col2, cost = 1+2+2 = 5
  let cost : Array[Array[Int]] = [[4, 1, 3], [2, 0, 5], [3, 2, 2]]
  let (assign, total) = hungarian_assignment(cost)
  assert_eq(total, 5)
  assert_true(is_perm(assign))
  assert_eq(assign[0], 1)
  assert_eq(assign[1], 0)
  assert_eq(assign[2], 2)
}

///|
test "hungarian_2x2" {
  let cost : Array[Array[Int]] = [[1, 2], [2, 1]]
  let (assign, total) = hungarian_assignment(cost)
  assert_eq(total, 2)
  assert_true(is_perm(assign))
  assert_eq(assign[0], 0)
  assert_eq(assign[1], 1)
}

///|
test "hungarian_diagonal_cheap" {
  let cost : Array[Array[Int]] = [[1, 9, 9], [9, 1, 9], [9, 9, 1]]
  let (assign, total) = hungarian_assignment(cost)
  assert_eq(total, 3)
  assert_true(is_perm(assign))
}

///|
test "hungarian_1x1" {
  let cost : Array[Array[Int]] = [[7]]
  let (assign, total) = hungarian_assignment(cost)
  assert_eq(total, 7)
  assert_eq(assign[0], 0)
}

///|
test "hungarian_4x4_antidiagonal" {
  // cost[r][c] = (r+1)*(c+1); min pairs large rows with small cols -> 20
  let cost : Array[Array[Int]] = [
    [1, 2, 3, 4],
    [2, 4, 6, 8],
    [3, 6, 9, 12],
    [4, 8, 12, 16],
  ]
  let (assign, total) = hungarian_assignment(cost)
  assert_eq(total, 20)
  assert_true(is_perm(assign))
}
