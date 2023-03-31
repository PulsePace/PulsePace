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
        let hasRemainingConstraint = remainingConstraints.contains(where: {
            $0.checkProperty(property: property)
        })
        if !hasRemainingConstraint {
            property.removeObserver(self)
        }
        notifyUnlock()
    }

    func initialiseConstraints(properties: [any Property]) {
        for constraint in constraints {
            constraint.bindProperty(from: properties)
        }
        subscribe()
    }

    private func subscribe() {
        for constraint in remainingConstraints {
            constraint.subscribeAchievement(self)
        }
    }
}
