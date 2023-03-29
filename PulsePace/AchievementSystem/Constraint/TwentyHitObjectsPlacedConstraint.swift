//
//  TwentyHitObjectsPlacedConstraint.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class TwentyHitObjectsPlacedConstraint: Constraint {
    typealias P = TotalHitObjectsPlacedProperty
    var property: P?
    var value = 20

    var isSatisfied: Bool {
        guard let property = property else {
            return false
        }
        return property.value >= value
    }
}
