//
//  TotalHitObjectsPlacedPropertyUpdater.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/31.
//

import Foundation

class TotalHitObjectsPlacedPropertyUpdater: PropertyUpdater {
    weak var property: TotalHitObjectsPlacedProperty?

    func increment() {
        guard let property = property else {
            return
        }
        property.updateValue(to: property.value + 1)
    }
}
