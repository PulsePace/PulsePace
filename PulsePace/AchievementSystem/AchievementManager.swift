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
        let property = TotalHitObjectsPlacedProperty()
        properties = [property]
        achievements
            = [NoviceBeatmapDesignerAchievement(properties: properties), ExpertBeatmapDesignerAchievement(properties: properties)]
    }

//    private func registerProperties() {
//
//    }
}
