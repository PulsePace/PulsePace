//
//  AchievementUpdateDelegate.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/16.
//

import Foundation

protocol AchievementUpdateDelegate: AnyObject {
    var isNotifying: Bool { get set }
    var notifyingAchievement: Achievement? { get set }

    func updateAchievementsProgress()
    func notifyUnlockedAchievement(_ achievement: Achievement)
    func unnotifyUnlockedAchievement()
}
