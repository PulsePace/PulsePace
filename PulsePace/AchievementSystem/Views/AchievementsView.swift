//
//  AchievementsView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/16.
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var achievementManager: AchievementManager

    var body: some View {
        ScrollView {
            ForEach(achievementManager.achievements, id: \.title) { achievement in
                VStack {
                    renderAchievement(achievement)
                }
            }
        }
        .navigationTitle("Achievements")
    }

    @ViewBuilder
    private func renderAchievement(_ achievement: Achievement) -> some View {
        VStack {
            Text(achievement.title)
            Text(achievement.description)
            ProgressView("Progress", value: achievement.progress, total: 1)
//            Text("\(achievement.progress)")
        }
    }
}
