//
//  PriorityQueue.swift
//  PulsePace
//
//  Referenced from:
//  https://www.kodeco.com/books/data-structures-algorithms-in-swift/v3.0/chapters/24-priority-queue
//  Created by Charisma Kausar on 14/3/23.
//

public struct PriorityQueue<T>: Queue {
    private var heap: Heap<T>
    private var comparator: (T, T) -> Bool

    init(sortBy comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
        self.heap = Heap<T>(sortBy: comparator)
    }

    public var count: Int {
        heap.count
    }

    public var isEmpty: Bool {
        heap.isEmpty
    }

    public mutating func enqueue(_ item: T) {
        heap.insert(item)
    }

    public mutating func dequeue() -> T? {
        heap.remove()
    }

    public mutating func removeAll() {
        heap = Heap<T>(sortBy: comparator)
    }

    public func peek() -> T? {
        heap.peek()
    }

    public func toArray() -> [T] {
        heap.toArray()
    }
}
