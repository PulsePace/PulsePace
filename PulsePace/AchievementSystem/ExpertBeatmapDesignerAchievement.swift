//
//  ExpertBeatmapDesignerAchievement.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class ExpertBeatmapDesignerAchievement: Achievement {
    var title: String = "Expert Beatmap Designer"
    var constraints: [any Constraint] = [
        TwentyHitObjectsPlacedConstraint()
    ]

    init(properties: [any Property]) {
        initialiseConstraints(properties: properties)
        subscribe()
    }
}
