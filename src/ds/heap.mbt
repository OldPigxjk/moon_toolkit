///|
/// MinHeap (binary heap) priority queue implementation.
/// Used by Dijkstra's and Prim's algorithms.
/// Always a min-heap keyed by priority (Int).
struct HeapEntry[T] {
  value : T
  priority : Int
}

///|
pub struct MinHeap[T] {
  data : Array[HeapEntry[T]]
}

///|
pub fn[T] MinHeap::new() -> MinHeap[T] {
  { data: [] }
}

///|
pub fn[T] MinHeap::length(self : MinHeap[T]) -> Int {
  self.data.length()
}

///|
pub fn[T] MinHeap::is_empty(self : MinHeap[T]) -> Bool {
  self.data.is_empty()
}

///|
pub fn[T] MinHeap::push(
  self : MinHeap[T],
  value : T,
  priority : Int,
) -> MinHeap[T] {
  let heap = self
  heap.data.push({ value, priority })
  let mut i = heap.data.length() - 1
  while i > 0 {
    let parent = (i - 1) / 2
    if heap.data[i].priority < heap.data[parent].priority {
      let tmp = heap.data[i]
      heap.data[i] = heap.data[parent]
      heap.data[parent] = tmp
      i = parent
    } else {
      break
    }
  }
  heap
}

///|
pub fn[T] MinHeap::pop(self : MinHeap[T]) -> (T?, MinHeap[T]) {
  if self.data.is_empty() {
    (None, self)
  } else {
    let h = self
    let top = h.data[0].value
    let last = h.data.length() - 1
    h.data[0] = h.data[last]
    h.data.unsafe_pop_back()
    let mut i = 0
    let len = h.data.length()
    while i < len {
      let left = 2 * i + 1
      let right = 2 * i + 2
      let mut smallest = i
      if left < len && h.data[left].priority < h.data[smallest].priority {
        smallest = left
      }
      if right < len && h.data[right].priority < h.data[smallest].priority {
        smallest = right
      }
      if smallest != i {
        let tmp = h.data[i]
        h.data[i] = h.data[smallest]
        h.data[smallest] = tmp
        i = smallest
      } else {
        break
      }
    }
    (Some(top), h)
  }
}

///|
pub fn[T] MinHeap::peek(self : MinHeap[T]) -> T? {
  if self.data.is_empty() {
    None
  } else {
    Some(self.data[0].value)
  }
}
