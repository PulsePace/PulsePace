//
//  Heap.swift
//  PulsePace
//
//  Created by Charisma Kausar on 14/3/23.
//

public struct Heap<T> {
    private var nodes: [T] = []
    private var comparator: (T, T) -> Bool

    var isEmpty: Bool {
        nodes.isEmpty
    }

    var count: Int {
        nodes.count
    }
}
