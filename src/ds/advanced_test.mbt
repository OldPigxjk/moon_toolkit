/// Test for Fenwick tree and Segment tree

///|
test "fenwick_basic_prefix" {
  let f = Fenwick::new(5)
  f.add(0, 1)
  f.add(1, 2)
  f.add(2, 3)
  f.add(3, 4)
  f.add(4, 5)
  assert_eq(f.prefix_sum(0), 1)
  assert_eq(f.prefix_sum(2), 6)
  assert_eq(f.prefix_sum(4), 15)
  assert_eq(f.range_sum(1, 3), 9)
  assert_eq(f.range_sum(0, 4), 15)
  assert_eq(f.range_sum(2, 2), 3)
}

///|
test "fenwick_point_update" {
  let f = Fenwick::new(5)
  f.add(0, 1)
  f.add(1, 2)
  f.add(2, 3)
  f.add(3, 4)
  f.add(4, 5)
  f.add(2, 10) // a[2] becomes 13
  assert_eq(f.prefix_sum(2), 16)
  assert_eq(f.range_sum(2, 4), 22)
  assert_eq(f.range_sum(3, 1), 0) // empty range
}

///|
test "seg_tree_range_sum" {
  let s = SegTree::from_array([1, 2, 3, 4, 5])
  assert_eq(s.query(0, 4), 15)
  assert_eq(s.query(1, 3), 9)
  assert_eq(s.query(2, 2), 3)
  assert_eq(s.query(3, 1), 0)
}

///|
test "seg_tree_set_and_add" {
  let s = SegTree::from_array([1, 2, 3, 4, 5])
  s.set(2, 10)
  assert_eq(s.query(0, 4), 22)
  assert_eq(s.query(2, 2), 10)
  s.add(0, 100)
  assert_eq(s.query(0, 0), 101)
  assert_eq(s.query(0, 4), 122)
}

///|
test "seg_tree_empty_and_single" {
  let e = SegTree::new(0)
  assert_eq(e.query(0, 0), 0)
  let one = SegTree::new(1)
  one.set(0, 7)
  assert_eq(one.query(0, 0), 7)
}
