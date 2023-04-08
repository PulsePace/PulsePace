//
//  MatchFeedView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 2/4/23.
//

import SwiftUI

struct MatchFeedView: View {
    @EnvironmentObject var gameVM: GameViewModel

    var body: some View {
        if gameVM.selectedGameMode.requires(gameViewElement: .matchFeed) {
            VStack {
                ForEach(gameVM.matchFeedMessages.sorted(by: { x, y in x.timestamp < y.timestamp }),
                        id: \.timestamp) { feed in
                    Text(feed.message)
                        .font(Fonts.caption)
                        .opacity(max(0, 1 - 0.1 * abs(Date().timeIntervalSince1970 - feed.timestamp)))
                        .zIndex(20)
                }
            }
            .padding(20)
        }
    }
}
