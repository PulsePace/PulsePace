//
//  TotalBeatmapDesignerOpenedProperty.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/30.
//

import Foundation

class TotalBeatmapDesignerOpenedProperty: Property {
    var name: String = "Total Beatmap Designer Opened"
    var value: Int = 0
    var observers: [Observer] = []
    var updater: TotalBeatmapDesignerOpenedPropertyUpdater

    init() {
        self.updater = TotalBeatmapDesignerOpenedPropertyUpdater()
        updater.property = self
    }
}
