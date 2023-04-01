//
//  AchievementManager.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class AchievementManager: ObservableObject {
    static let shared = AchievementManager() // TODO: remove singleton

    var properties: [any Property] = [] // TODO: private
    var achievements: [any Achievement] = []

    init() {
        properties = [
            TotalHitObjectsPlacedProperty(),
            TotalBeatmapDesignerOpenedProperty()
        ]
        achievements = [
            NoviceBeatmapDesignerAchievement(),
            ExpertBeatmapDesignerAchievement()
        ]
        registerProperties()
    }

    private func registerProperties() {
        for achievement in achievements {
            achievement.initialiseConstraints(properties: properties)
        }
    }
}
