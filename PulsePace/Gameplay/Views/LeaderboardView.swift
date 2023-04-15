//
//  LeaderboardView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/4/23.
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var gameVM: GameViewModel

    var body: some View {
        if gameVM.selectedGameMode.requires(gameViewElement: .leaderboard) {
            VStack(alignment: .trailing) {
                ForEach(Array(gameVM.leaderboard.enumerated()), id: \.offset) { index, player in
                    HStack {
                        Text("\(index + 1). \(player.key)")
                            .font(Fonts.caption)
                        Spacer()
                        Text("\(player.value)")
                            .font(Fonts.caption)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .foregroundColor(getColorForIndex(index))
                }
            }
            .padding(20)
            .frame(maxWidth: 300)
            .background(.thinMaterial)
        }
    }

    func getColorForIndex(_ index: Int) -> Color {
        switch index {
        case 0:
            return Color.yellow
        case 1:
            return Color.gray
        case 2:
            return Color.brown
        default:
            return Color.white
        }
    }
}
