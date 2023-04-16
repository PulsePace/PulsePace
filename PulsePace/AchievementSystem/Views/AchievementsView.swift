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
            VStack(spacing: 16) {
                ForEach(achievementManager.achievements, id: \.title) { achievement in
                    renderAchievement(achievement)
                }
            }
            .padding(.init(top: 0, leading: 160, bottom: 0, trailing: 160))
        }
        .navigationTitle("Achievements")
    }

    @ViewBuilder
    private func renderAchievement(_ achievement: Achievement) -> some View {
        HStack {
            Image(achievement.imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
                .padding(12)

            VStack(alignment: .leading, spacing: 12) {
                Text(achievement.title)
                    .font(Font.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                Text(achievement.description)
                    .font(.subheadline)
                    .font(Font.system(size: 20, weight: .light))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 4)
                ProgressView(value: achievement.progress, total: 1)
                    .tint(.white)
            }

            Spacer()
        }
        .frame(height: 120)
        .background(.purple)
        .cornerRadius(12)
    }
}
