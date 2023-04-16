//
//  AchievementManager.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class AchievementManager: ObservableObject, AchievementUpdateDelegate {
    private(set) var achievements: [any Achievement]
    @Published var isNotifying = false
    @Published var notifyingAchievement: Achievement?

    init() {
        achievements = [
            NoviceBeatmapDesignerAchievement(),
            ExpertBeatmapDesignerAchievement(),
            SwiftFingersAchievement()
        ]
        bindUpdateDelegate()
    }

    private func bindUpdateDelegate() {
        for achievement in achievements {
            achievement.delegate = self
        }
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

    func notifyUnlockedAchievement(_ achievement: Achievement) {
        isNotifying = true
        notifyingAchievement = achievement
    }

    func unnotifyUnlockedAchievement() {
        isNotifying = false
        notifyingAchievement = nil
    }
}
