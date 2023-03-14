//
//  Heap.swift
//  PulsePace
//
//  Imported from: https://github.com/kodecocodes/swift-algorithm-club/blob/master/Heap/Heap.swift
//  Created by Charisma Kausar on 14/3/23.
//

public struct Heap<T> {
    private var nodes: [T] = []
    private var comparator: (T, T) -> Bool

    init(sortBy comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
    }

    init(values: [T], sortBy comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
        configureHeap(fromValues: values)
    }

    var isEmpty: Bool {
        nodes.isEmpty
    }

    var count: Int {
        nodes.count
    }

    public func peek() -> T? {
        nodes.first
    }

    public mutating func insertValues<S: Sequence>(_ values: S) where S.Iterator.Element == T {
        for value in values {
          insert(value)
        }
    }

    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }

    public mutating func remove() -> T? {
        guard !nodes.isEmpty else {
            return nil
        }

        if nodes.count == 1 {
          return nodes.removeLast()
        }

        let value = nodes[0]
        nodes[0] = nodes.removeLast()
        shiftDown(0)
        return value
    }

    public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else {
            return nil
        }

        let size = nodes.count - 1
        if index != size {
          nodes.swapAt(index, size)
          shiftDown(from: index, until: size)
          shiftUp(index)
        }
        return nodes.removeLast()
      }

    public mutating func replace(index i: Int, value: T) {
        guard i < nodes.count else {
            return
        }

        _ = remove(at: i)
        insert(value)
    }

    public func toArray() -> [T] {
        nodes
    }

    private mutating func configureHeap(fromValues values: [T]) {
        nodes = values
        for i in stride(from: ((nodes.count / 2) - 1), through: 0, by: -1) {
          shiftDown(i)
        }
    }

    private mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)

        while childIndex > 0 && comparator(child, nodes[parentIndex]) {
          nodes[childIndex] = nodes[parentIndex]
          childIndex = parentIndex
          parentIndex = self.parentIndex(ofIndex: childIndex)
        }

        nodes[childIndex] = child
    }

    private mutating func shiftDown(_ index: Int) {
      shiftDown(from: index, until: nodes.count)
    }

    private mutating func shiftDown(from currIndex: Int, until endIndex: Int) {
      let leftChildIndex = self.leftChildIndex(ofIndex: currIndex)
      let rightChildIndex = leftChildIndex + 1

      var first = currIndex
      if leftChildIndex < endIndex && comparator(nodes[leftChildIndex], nodes[first]) {
        first = leftChildIndex
      }
      if rightChildIndex < endIndex && comparator(nodes[rightChildIndex], nodes[first]) {
        first = rightChildIndex
      }
      if first == currIndex {
          return
      }

      nodes.swapAt(currIndex, first)
      shiftDown(from: first, until: endIndex)
    }

    private func parentIndex(ofIndex i: Int) -> Int {
        (i - 1) / 2
      }

    private func leftChildIndex(ofIndex i: Int) -> Int {
        (2 * i) + 1
    }

    private func rightChildIndex(ofIndex i: Int) -> Int {
        (2 * i) + 2
    }
}

// MARK: - Searching
extension Heap where T: Equatable {
    public func index(of node: T) -> Int? {
        nodes.firstIndex(where: { $0 == node })
    }

    public mutating func remove(node: T) -> T? {
        if let index = index(of: node) {
          return remove(at: index)
        }
        return nil
    }
}
