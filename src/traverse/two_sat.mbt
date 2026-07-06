/// 2-SAT solver via Strongly Connected Components (Kosaraju).
///
/// Variables are x0, x1, ..., x_{n-1}. A literal is encoded as an integer:
///   literal 2*i     represents ¬x_i
///   literal 2*i + 1 represents  x_i
///
/// `clauses` is a list of (a, b), each meaning the disjunction (a OR b).
/// The function returns `Some(assignment)` where `assignment[i]` is the value
/// of x_i when the formula is satisfiable, or `None` otherwise.
/// Time complexity: O(V + E) with V = 2n.

// Negate a literal: flip the low bit.
fn ts_neg(l: Int) -> Int {
  if l % 2 == 0 { l + 1 } else { l - 1 }
}

/// Solve a 2-SAT instance.
/// Returns `Some(assignment)` if satisfiable, `None` otherwise.
pub fn two_sat_solve(
  n: Int,
  clauses: Array[(Int, Int)],
) -> Array[Bool]? {
  let v = 2 * n
  let g : @graph.Graph[Int, Int] = @graph.Graph::new()
  for i = 0; i < v; i = i + 1 {
    let _ = g.add_node(0)
  }
  for c = 0; c < clauses.length(); c = c + 1 {
    let (a, b) = clauses[c]
    // (a ∨ b) ≡ (¬a → b) ∧ (¬b → a)
    let _ = g.add_edge(ts_neg(a), b, 1)
    let _ = g.add_edge(ts_neg(b), a, 1)
  }
  let comp = kosaraju_component_ids(g)
  let assign : Array[Bool] = []
  for i = 0; i < n; i = i + 1 {
    if comp[2 * i] == comp[2 * i + 1] {
      return None
    }
    // Assign the literal whose SCC is discovered later by Kosaraju (higher
    // component id). Processing components in decreasing id order and setting
    // the first-seen literal true yields a valid satisfying assignment.
    assign.push(comp[2 * i + 1] > comp[2 * i])
  }
  Some(assign)
}
