//
//  NoviceBeatmapDesignerAchievement.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class NoviceBeatmapDesignerAchievement: Achievement {
    let title: String = "Novice Beatmap Designer"
    let description: String = "Open the beatmap designer two times"
    var propertyStorage: PropertyStorage?
    var isUnlocked = false

    private let beatmapDesignerOpenedRequirement = 2

    var progress: Double {
        guard let beatmapDesignerOpened = propertyStorage?.beatmapDesignerOpened.value else {
            return 0
        }
        let beatmapDesignerOpenedRatio = Double(beatmapDesignerOpened) / Double(beatmapDesignerOpenedRequirement)
        return beatmapDesignerOpenedRatio
    }

    var areConstraintsSatisfied: Bool {
        guard let propertyStorage = propertyStorage else {
            return false
        }
        return propertyStorage.beatmapDesignerOpened.value >= 2
    }
}
