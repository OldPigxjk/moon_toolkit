/// Test for MinHeap binary heap data structure

///|
test "heap_push_and_pop_basic" {
  let h = MinHeap::new()
  let h = h.push("a", 3)
  let h = h.push("b", 1)
  let h = h.push("c", 2)

  // Pop order should be by priority: b(1), c(2), a(3)
  let (opt_a, h) = h.pop()
  match opt_a {
    Some(v) => assert_eq(v, "b")
    None => fail("Expected Some, got None")
  }

  let (opt_b, h) = h.pop()
  match opt_b {
    Some(v) => assert_eq(v, "c")
    None => fail("Expected Some, got None")
  }

  let (opt_c, _) = h.pop()
  match opt_c {
    Some(v) => assert_eq(v, "a")
    None => fail("Expected Some, got None")
  }
}

///|
test "heap_empty_behavior" {
  let h : MinHeap[String] = MinHeap::new()

  assert_true(h.is_empty())
  assert_eq(h.length(), 0)

  let (opt, _) = h.pop()
  match opt {
    Some(_) => fail("Expected None from empty heap pop")
    None => ()
  }

  let peek_opt = h.peek()
  match peek_opt {
    Some(_) => fail("Expected None from empty heap peek")
    None => ()
  }
}

///|
test "heap_peek_does_not_remove" {
  let h = MinHeap::new()
  let h = h.push(42, 5)
  let h = h.push(10, 1)

  // Peek should return smallest without removing
  let peek_opt = h.peek()
  match peek_opt {
    Some(v) => assert_eq(v, 10)
    None => fail("Expected Some from peek")
  }

  // Length unchanged
  assert_eq(h.length(), 2)
}

///|
test "heap_equal_priorities" {
  let h = MinHeap::new()
  let h = h.push("x", 7)
  let h = h.push("y", 7)
  let h = h.push("z", 7)

  // All have same priority; all should be popped
  assert_eq(h.length(), 3)
  let (opt1, h) = h.pop()
  match opt1 {
    Some(_) => ()
    None => fail("expected Some")
  }
  let (opt2, h) = h.pop()
  match opt2 {
    Some(_) => ()
    None => fail("expected Some")
  }
  let (opt3, h) = h.pop()
  match opt3 {
    Some(_) => ()
    None => fail("expected Some")
  }
  assert_true(h.is_empty())
}

///|
test "heap_negative_priorities" {
  let h = MinHeap::new()
  let h = h.push("neg", -10)
  let h = h.push("zero", 0)
  let h = h.push("pos", 10)

  let (first, h) = h.pop()
  match first {
    Some(v) => assert_eq(v, "neg")
    None => fail("expected Some")
  }
  let (second, h) = h.pop()
  match second {
    Some(v) => assert_eq(v, "zero")
    None => fail("expected Some")
  }
  let (third, _) = h.pop()
  match third {
    Some(v) => assert_eq(v, "pos")
    None => fail("expected Some")
  }
}
