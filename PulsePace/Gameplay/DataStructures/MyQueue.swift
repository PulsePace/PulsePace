//
//  Queue.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

struct MyQueue<T> {
    private var items: [T] = []
    private var frontPointer = 0
    private var backPointer = 0
    private let batchRemovalCount = 32

    /// Adds an element to the tail of the queue.
    /// - Parameter item: The element to be added to the queue
    mutating func enqueue(_ item: T) {
        items.append(item)
        backPointer += 1
    }

    /// Removes an element from the head of the queue and return it.
    /// - Returns: item at the head of the queue
    mutating func dequeue() -> T? {
        if backPointer - frontPointer == 0 {
            return nil
        }

        let item = items[frontPointer]
        frontPointer += 1
        if frontPointer == batchRemovalCount {
            items.removeSubrange(0..<batchRemovalCount)
            frontPointer -= batchRemovalCount
            backPointer -= batchRemovalCount
        }
        return item
    }

    /// Returns, but does not remove, the element at the head of the queue.
    /// - Returns: item at the head of the queue
    func peek() -> T? {
        if isEmpty {
            return nil
        }

        return items[frontPointer]
    }

    /// The number of elements currently in the queue.
    var itemCount: Int {
        backPointer - frontPointer
    }

    /// Whether the queue is empty.
    var isEmpty: Bool {
        itemCount == 0
    }

    /// Removes all elements in the queue.
    mutating func removeAll() {
        items.removeAll()
        frontPointer = 0
        backPointer = 0
    }

    /// Returns an array of the elements in their respective dequeue order, i.e.
    /// first element in the array is the first element to be dequeued.
    /// - Returns: array of elements in their respective dequeue order
    func toArray() -> [T] {
        items.suffix(itemCount)
    }
}
