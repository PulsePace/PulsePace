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

    func bindProperty(from properties: [any Property])
}

extension Constraint {
    func bindProperty(from properties: [any Property]) {
        for property in properties {
            if let property = property as? P {
                self.property = property
                return
            }
        }
    }
}
