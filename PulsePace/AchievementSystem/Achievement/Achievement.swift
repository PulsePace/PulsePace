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

    func handleUnlock() {
        guard isUnlocked else {
            return
        }
        print("Unlocked \(title)")
    }

    func update<T: Observable>(with observable: T) {
        guard let property = observable as? any Property else {
            return
        }
        handleUnsubscribe(property: property)
        handleUnlock()
    }

    private func handleUnsubscribe(property: any Property) {
        let hasRemainingConstraint = remainingConstraints.contains(where: {
            $0.checkProperty(property: property)
        })
        if !hasRemainingConstraint {
            property.removeObserver(self)
        }
    }

    func initialiseConstraints(properties: [any Property]) {
        bindProperties(properties: properties)
        subscribe()
    }

    private func bindProperties(properties: [any Property]) {
        for constraint in constraints {
            constraint.bindProperty(from: properties)
        }
    }

    private func subscribe() {
        for constraint in remainingConstraints {
            constraint.subscribeAchievement(self)
        }
    }
}
