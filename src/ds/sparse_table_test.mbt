/// Tests for Sparse Table (static Range Minimum Query).

///|
test "sparse_table_basic" {
  let a = [4, 2, 8, 1, 9, 3, 5, 7]
  let st = SparseTable::from_array(a)
  assert_eq(st.query_min(0, 0), 4)
  assert_eq(st.query_min(0, 7), 1)
  assert_eq(st.query_min(3, 3), 1)
  assert_eq(st.query_min(2, 4), 1)
  assert_eq(st.query_min(0, 2), 2)
  assert_eq(st.query_min(4, 6), 3)
}

///|
test "sparse_table_single" {
  let st = SparseTable::from_array([42])
  assert_eq(st.query_min(0, 0), 42)
}

///|
test "sparse_table_empty" {
  // Empty array: any index is out of range -> INF sentinel.
  let st = SparseTable::from_array([])
  assert_eq(st.query_min(0, 0), 2147483647)
}

///|
test "sparse_table_out_of_range" {
  let a = [4, 2, 8, 1, 9]
  let st = SparseTable::from_array(a)
  assert_eq(st.query_min(2, 10), 2147483647) // r >= n
  assert_eq(st.query_min(-1, 2), 2147483647) // l < 0
  assert_eq(st.query_min(3, 2), 2147483647) // l > r
}

///|
test "sparse_table_negative" {
  let a = [3, -5, 2, -1, 0]
  let st = SparseTable::from_array(a)
  assert_eq(st.query_min(0, 4), -5)
  assert_eq(st.query_min(1, 3), -5)
  assert_eq(st.query_min(2, 4), -1)
}
