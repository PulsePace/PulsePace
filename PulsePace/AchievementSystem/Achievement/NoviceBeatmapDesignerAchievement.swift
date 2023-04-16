//
//  NoviceBeatmapDesignerAchievement.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class NoviceBeatmapDesignerAchievement: Achievement {
    let title: String = "Novice Beatmap Designer"
    let description: String = "Open the beatmap designer two times."
    let imageName: String = "novice-beatmap-designer-achievement"
    var propertyStorage: PropertyStorage?
    var isUnlocked = false
    weak var delegate: AchievementUpdateDelegate?

    private let beatmapDesignerOpenedRequirement = 2

    var progress: Double {
        guard let beatmapDesignerOpened = propertyStorage?.beatmapDesignerOpened.value else {
            return 0
        }
        let beatmapDesignerOpenedRatio = min(
            Double(beatmapDesignerOpened) / Double(beatmapDesignerOpenedRequirement), 1
        )
        return beatmapDesignerOpenedRatio
    }

    var areConstraintsSatisfied: Bool {
        guard let propertyStorage = propertyStorage else {
            return false
        }
        return propertyStorage.beatmapDesignerOpened.value >= beatmapDesignerOpenedRequirement
    }
}
