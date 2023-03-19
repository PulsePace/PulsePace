//
//  MyQueueTests.swift
//  PulsePaceTests
//
//  Created by James Chiu on 19/3/23.
//

import XCTest
@testable import PulsePace

final class MyQueueTests: XCTestCase {
    func testEnqueue() {
        var queue = MyQueue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        XCTAssertEqual(queue.itemCount, 3)
    }

    func testDequeue() {
        var queue = MyQueue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        let item = queue.dequeue()
        XCTAssertEqual(item, 1)
        XCTAssertEqual(queue.itemCount, 2)
    }

    func testPeek() {
        var queue = MyQueue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        let item = queue.peek()
        XCTAssertEqual(item, 1)
        XCTAssertEqual(queue.itemCount, 3)
    }

    func testItemCount() {
        var queue = MyQueue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        XCTAssertEqual(queue.itemCount, 3)
    }

    func testIsEmpty() {
        var queue = MyQueue<Int>()
        XCTAssertTrue(queue.isEmpty)
        queue.enqueue(1)
        XCTAssertFalse(queue.isEmpty)
    }

    func testRemoveAll() {
        var queue = MyQueue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        queue.removeAll()
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.itemCount, 0)
    }

    func testToArray() {
        var queue = MyQueue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        let array = queue.toArray()
        XCTAssertEqual(array, [1, 2, 3])
    }
}
