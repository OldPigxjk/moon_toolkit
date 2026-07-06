/// Tests for 2-SAT solver.

// Decode a literal under an assignment: literal 2*i = ¬x_i, 2*i+1 = x_i.
fn ts_val(assign: Array[Bool], lit: Int) -> Bool {
  let i = lit / 2
  let positive = lit % 2 == 1
  if positive { assign[i] } else { !assign[i] }
}

// Verify every clause is satisfied by the assignment.
fn ts_check(clauses: Array[(Int, Int)], assign: Array[Bool]) -> Bool {
  for c = 0; c < clauses.length(); c = c + 1 {
    let (a, b) = clauses[c]
    if !(ts_val(assign, a) || ts_val(assign, b)) {
      return false
    }
  }
  true
}

///|
test "two_sat_satisfiable" {
  // (x0 ∨ x1) ∧ (¬x0 ∨ x2) ∧ (¬x1 ∨ ¬x2)
  let clauses = [(0, 3), (1, 4), (3, 5)]
  let r = two_sat_solve(3, clauses)
  match r {
    Some(assign) => { assert_eq(ts_check(clauses, assign), true) }
    None => { fail("instance is satisfiable") }
  }
}

///|
test "two_sat_unsatisfiable" {
  // (x0) ∧ (¬x0):  literal 1 = x0, literal 0 = ¬x0.
  let clauses = [(1, 1), (0, 0)]
  let r = two_sat_solve(1, clauses)
  assert_true(r is None)
}

///|
test "two_sat_single_var_true" {
  // (x0 ∨ x0) forces x0 = true.
  let clauses = [(1, 1)]
  let r = two_sat_solve(1, clauses)
  match r {
    Some(assign) => {
      assert_eq(assign[0], true)
      assert_eq(ts_check(clauses, assign), true)
    }
    None => { fail("trivially satisfiable") }
  }
}

///|
test "two_sat_four_vars" {
  // A larger satisfiable instance.
  let clauses = [
    (0, 3), // x0 ∨ x1
    (2, 5), // x1 ∨ x2
    (4, 7), // x2 ∨ x3
    (1, 6), // ¬x0 ∨ x3
    (3, 4), // ¬x1 ∨ x2
  ]
  let r = two_sat_solve(4, clauses)
  match r {
    Some(assign) => { assert_eq(ts_check(clauses, assign), true) }
    None => { fail("instance is satisfiable") }
  }
}

///|
test "two_sat_contradiction_pair" {
  // (x0 ∨ x1) ∧ (¬x0 ∨ x1) ∧ (x0 ∨ ¬x1) ∧ (¬x0 ∨ ¬x1) -> unsatisfiable.
  let clauses = [(1, 3), (0, 3), (1, 2), (0, 2)]
  let r = two_sat_solve(2, clauses)
  assert_true(r is None)
}
