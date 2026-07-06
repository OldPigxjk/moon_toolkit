/// Tests for Lazy Segment Tree (range addition + range sum).

///|
test "lazy_seg_basic" {
  let t = LazySegTree::from_array([1, 2, 3, 4, 5])
  assert_eq(t.range_sum(0, 4), 15)
  assert_eq(t.range_sum(1, 3), 9)
  assert_eq(t.range_sum(2, 2), 3)
}

///|
test "lazy_seg_range_add" {
  let t = LazySegTree::from_array([1, 2, 3, 4, 5])
  t.range_add(1, 3, 10) // indices 1,2,3 become 12,13,14
  assert_eq(t.range_sum(0, 4), 45)
  assert_eq(t.range_sum(1, 3), 39)
  assert_eq(t.range_sum(0, 0), 1)
  assert_eq(t.range_sum(4, 4), 5)
}

///|
test "lazy_seg_multiple_adds" {
  let t = LazySegTree::from_array([0, 0, 0, 0])
  t.range_add(0, 3, 5)
  t.range_add(1, 2, 3) // a[1],a[2] += 3
  assert_eq(t.range_sum(0, 3), 26)
  assert_eq(t.range_sum(1, 2), 16)
}

///|
test "lazy_seg_single_node" {
  let t = LazySegTree::new(1)
  assert_eq(t.range_sum(0, 0), 0)
  t.range_add(0, 0, 7)
  assert_eq(t.range_sum(0, 0), 7)
}

///|
test "lazy_seg_empty" {
  let t = LazySegTree::new(0)
  assert_eq(t.range_sum(0, 0), 0)
  t.range_add(0, 0, 5) // n == 0 -> no-op
  assert_eq(t.range_sum(0, 4), 0)
}
