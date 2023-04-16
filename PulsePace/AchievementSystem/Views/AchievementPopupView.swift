//
//  AchievementPopupView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/16.
//

import SwiftUI

struct AchievementPopupView: View {
    var achievement: Achievement

    var body: some View {
        HStack(spacing: 12) {
            Image(achievement.imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                Text("Achievement Unlocked!")
                    .font(.headline)
                    .font(Font.system(size: 24, weight: .semibold))
                HStack {
                    Text(achievement.title)
                        .font(.subheadline)
                        .font(Font.system(size: 20, weight: .bold))
                    Text("\u{00B7}")
                    Text(achievement.description)
                        .font(.subheadline)
                        .font(Font.system(size: 20, weight: .light))
                        .foregroundColor(.white.opacity(0.75))
                }
            }
            .padding(.trailing, 8)
        }
        .frame(height: 80)
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct AchievementPopupView_Previews: PreviewProvider {
    static var previews: some View {
        let achievement = NoviceBeatmapDesignerAchievement()
        AchievementPopupView(achievement: achievement)
    }
}
