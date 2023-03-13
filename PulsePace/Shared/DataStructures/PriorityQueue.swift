//
//  PriorityQueue.swift
//  PulsePace
//
//  Created by Charisma Kausar on 14/3/23.
//

public struct PriorityQueue<T: Equatable>: Queue {
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
