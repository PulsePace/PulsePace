//
//  Queue.swift
//  PulsePace
//
//  Created by Charisma Kausar on 14/3/23.
//

public protocol Queue {
    associatedtype T
    mutating func enqueue(_ item: T)
    mutating func dequeue() -> T?
    mutating func removeAll()
    func peek() -> T?
    func toArray() -> [T]
    var count: Int { get }
    var isEmpty: Bool { get }
}
