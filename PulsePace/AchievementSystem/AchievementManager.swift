//
//  AchievementManager.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/27.
//

import Foundation

class AchievementManager: ObservableObject {
    private var properties: [any Property]
    private var achievements: [any Achievement]

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

    func getPropertyUpdater<T: Property>(for propertyType: T.Type) -> T.S {
        guard let property = properties.first(where: { type(of: $0) == propertyType }) else {
            fatalError("Property for property \(propertyType) not found")
        }
        guard let updater = property.updater as? T.S else {
            fatalError("Updater for property \(propertyType) not found")
        }
        return updater
    }
}
