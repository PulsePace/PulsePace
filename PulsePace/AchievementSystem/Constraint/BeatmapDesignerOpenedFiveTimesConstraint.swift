//
//  BeatmapDesignerOpenedFiveTimesConstraint.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/30.
//

import Foundation

class BeatmapDesignerOpenedFiveTimesConstraint: Constraint {
    typealias P = TotalBeatmapDesignerOpenedProperty
    var property: P?
    var value: Int = 5

    var isSatisfied: Bool {
        guard let property = property else {
            return false
        }
        return property.value >= value
    }
}
