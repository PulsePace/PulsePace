//
//  NoviceBeatmapDesignerAchievement.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class NoviceBeatmapDesignerAchievement: Achievement {
    var title: String = "Novice Beatmap Designer"
    var constraints: [any Constraint] = [
        TenHitObjectsPlacedConstraint()
    ]

    init(properties: [any Property]) {
        initialiseConstraints(properties: properties)
        subscribe()
    }
}
