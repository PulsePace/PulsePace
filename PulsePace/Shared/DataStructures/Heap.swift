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

    private mutating func configureHeap(fromValues values: [T]) {
        nodes = values
        for i in stride(from: ((nodes.count / 2) - 1), through: 0, by: -1) {
          shiftDown(i)
        }
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

    private func leftChildIndex(ofIndex i: Int) -> Int {
        (2 * i) + 1
    }

    private func rightChildIndex(ofIndex i: Int) -> Int {
        (2 * i) + 2
    }
}
