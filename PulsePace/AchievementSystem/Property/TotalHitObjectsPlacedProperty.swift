//
//  TotalHitObjectsPlacedProperty.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class TotalHitObjectsPlacedProperty: Property {
    var name: String = "Total Hit Objects Placed"
    var value: Int = 0
    var observers: [Observer] = []
    var updater: TotalHitObjectsPlacedPropertyUpdater

    init() {
        self.updater = TotalHitObjectsPlacedPropertyUpdater()
        updater.property = self
    }
}
