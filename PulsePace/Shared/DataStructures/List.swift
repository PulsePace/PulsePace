//
//  List.swift
//  PulsePace
//
//  Created by James Chiu on 16/4/23.
//

import Foundation

// By reference instead of value
final class RefArray<T> {
    private var items: [T]

    init(_ items: [T] = []) {
        self.items = items
    }

    func add(_ item: T) {
        items.append(item)
    }

    var count: Int {
        items.count
    }

    var isEmpty: Bool {
        items.isEmpty
    }

    func removeAt(_ index: Int) {
        items.remove(at: index)
    }

    func map<U>(_ transform: @escaping (T) -> U) -> RefArray<U> {
        var transformedItems: [U] = []
        items.forEach { transformedItems.append(transform($0)) }
        return RefArray<U>(transformedItems)
    }

    func toArray() -> [T] {
        items
    }
}

extension RefArray<SerializedNamedBeatmap>: Codable {}
