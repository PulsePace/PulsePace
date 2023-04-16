//
//  SwiftFingersAchievement.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/15.
//

import Foundation

class SwiftFingersAchievement: Achievement {
    let title: String = "Swift Fingers"
    let description: String = "Obtain a lifetime score of 5,000"
    var propertyStorage: PropertyStorage?
    var isUnlocked = false

    private let lifetimeScoreRequirement = 5_000

    var progress: Double {
        guard let lifetimeScore = propertyStorage?.lifetimeScore.value else {
            return 0
        }
        let lifetimeScoreRatio = Double(lifetimeScore) / Double(lifetimeScoreRequirement)
        return lifetimeScoreRatio
    }

    var areConstraintsSatisfied: Bool {
        guard let propertyStorage = propertyStorage else {
            return false
        }
        return propertyStorage.lifetimeScore.value >= 5_000
    }
}
