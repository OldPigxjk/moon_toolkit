///|
test "union_find_basic" {
  let uf = UnionFind::new(5)
  assert_eq(UnionFind::connected(uf, 0, 1), false)
  let (_, new_uf) = UnionFind::union_set(uf, 0, 1)
  assert_eq(UnionFind::connected(new_uf, 0, 1), true)
  assert_eq(UnionFind::find(new_uf, 0), UnionFind::find(new_uf, 1))
}

///|
test "union_find_reflexive" {
  let uf = UnionFind::new(3)
  assert_eq(UnionFind::connected(uf, 0, 0), true)
  assert_eq(UnionFind::connected(uf, 1, 1), true)
  assert_eq(UnionFind::connected(uf, 2, 2), true)
}
