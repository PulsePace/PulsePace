//
//  ExpertBeatmapDesignerAchievement.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class ExpertBeatmapDesignerAchievement: Achievement {
    let title: String = "Expert Beatmap Designer"
    let description: String = "Open the beatmap designer five times and place ten hit objects."
    let imageName: String = "expert-beatmap-designer-achievement"
    var propertyStorage: PropertyStorage?
    var isUnlocked = false
    weak var delegate: AchievementUpdateDelegate?

    private let beatmapDesignerOpenedRequirement = 5
    private let hitObjectsPlacedRequirement = 10

    var progress: Double {
        guard let beatmapDesignerOpened = propertyStorage?.beatmapDesignerOpened.value,
              let hitObjectsPlaced = propertyStorage?.hitObjectsPlaced.value else {
            return 0
        }
        let beatmapDesignerOpenedRatio = min(
            Double(beatmapDesignerOpened) / Double(beatmapDesignerOpenedRequirement), 1
        )
        let hitObjectsPlacedRatio = min(
            Double(hitObjectsPlaced) / Double(hitObjectsPlacedRequirement), 1
        )
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
