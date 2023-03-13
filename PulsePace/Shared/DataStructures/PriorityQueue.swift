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

    public mutating func enqueue(_item: T) {
        }

    public mutating func dequeue() -> T? {
        nil
    }

    public mutating func removeAll() {
        }

    public func peek() -> T? {
        nil
    }

    public func toArray() -> [T] {
        []
    }

    public var count: Int

    public var isEmpty: Bool

}
