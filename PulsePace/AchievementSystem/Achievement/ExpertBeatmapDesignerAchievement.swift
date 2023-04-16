//
//  ExpertBeatmapDesignerAchievement.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class ExpertBeatmapDesignerAchievement: Achievement {
    let title: String = "Expert Beatmap Designer"
    let description: String = "Open the beatmap designer five times and place ten hit objects"
    var propertyStorage: PropertyStorage?
    var isUnlocked = false

    private let beatmapDesignerOpenedRequirement = 5
    private let hitObjectsPlacedRequirement = 10

    var progress: Double {
        guard let beatmapDesignerOpened = propertyStorage?.beatmapDesignerOpened.value,
              let hitObjectsPlaced = propertyStorage?.hitObjectsPlaced.value else {
            return 0
        }
        let beatmapDesignerOpenedRatio = Double(beatmapDesignerOpened) / Double(beatmapDesignerOpenedRequirement)
        let hitObjectsPlacedRatio = Double(hitObjectsPlaced) / Double(hitObjectsPlacedRequirement)
        return 0.5 * beatmapDesignerOpenedRatio + 0.5 * hitObjectsPlacedRatio
    }

    var areConstraintsSatisfied: Bool {
        guard let propertyStorage = propertyStorage else {
            return false
        }
        return propertyStorage.beatmapDesignerOpened.value >= 5
            && propertyStorage.hitObjectsPlaced.value >= 10
    }
}
