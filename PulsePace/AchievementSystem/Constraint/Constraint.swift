//
//  Constraint.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/26.
//

import Foundation

protocol Constraint: AnyObject {
    associatedtype P: Property
    var property: P? { get set }
    var value: P.T { get set }
    var isSatisfied: Bool { get }
}

extension Constraint {
    func bindProperty(from properties: [any Property]) {
        for property in properties {
            if let property = property as? P {
                self.property = property
                return
            }
        }
        fatalError("Property \(P.self) not found for constraint \(Self.self)")
    }

    func checkProperty(property: any Property) -> Bool {
        self.property === property
    }

    func subscribeAchievement(_ achievement: some Achievement) {
        property?.addObserver(achievement)
    }
}
