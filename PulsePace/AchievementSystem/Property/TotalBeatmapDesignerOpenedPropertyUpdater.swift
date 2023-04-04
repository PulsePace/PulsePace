//
//  TotalBeatmapDesignerOpenedPropertyUpdater.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/31.
//

import Foundation

class TotalBeatmapDesignerOpenedPropertyUpdater: PropertyUpdater {
    weak var property: TotalBeatmapDesignerOpenedProperty?

    func increment() {
        guard let property = property else {
            return
        }
        property.updateValue(to: property.value + 1)
    }
}
