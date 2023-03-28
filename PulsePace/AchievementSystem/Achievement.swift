//
//  Achievement.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/26.
//

import Foundation

protocol Achievement: Observer {
    var title: String { get }
    var constraints: [any Constraint] { get }
    var remainingConstraints: [any Constraint] { get }
    var isUnlocked: Bool { get }
}

extension Achievement {
    var remainingConstraints: [any Constraint] {
        constraints.filter { !$0.isSatisfied }
    }

    var isUnlocked: Bool {
        remainingConstraints.isEmpty
    }

    func notifyUnlock() {
        guard isUnlocked else {
            return
        }
        print("Unlocked \(title)")
    }

    func update(with observable: Observable) {
        guard let property = observable as? any Property else {
            return
        }
        let hasRemainingConstraint = remainingConstraints.contains(where: { $0.property === property })
        if !hasRemainingConstraint {
            property.removeObserver(self)
        }
        notifyUnlock()
        print(isUnlocked)
    }

    func subscribe() {
        var properties: [any Property] = []
        remainingConstraints.forEach { constraint in
            properties.removeAll(where: { $0 === constraint.property })
            properties.append(constraint.property)
        }
        properties.forEach { $0.addObserver(self) }
    }

    func initialiseConstraints(properties: [any Property]) {
        constraints.forEach { $0.bindProperty(from: properties) }
    }
}
