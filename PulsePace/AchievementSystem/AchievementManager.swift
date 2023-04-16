//
//  AchievementManager.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class AchievementManager: ObservableObject {
    private(set) var achievements: [any Achievement]

    init() {
        achievements = [
            NoviceBeatmapDesignerAchievement(),
            ExpertBeatmapDesignerAchievement(),
            SwiftFingersAchievement()
        ]
    }

    func updateAchievementsProgress() {
        for achievement in achievements {
            achievement.updateProgress()
        }
    }

    func registerPropertyStorage(_ propertyStorage: PropertyStorage) {
        for achievement in achievements {
            achievement.propertyStorage = propertyStorage
        }
    }
}
