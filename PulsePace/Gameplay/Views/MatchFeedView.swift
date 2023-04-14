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
                ForEach(gameVM.matchFeedMessages, id: \.timestamp) { feed in
                    ZStack {
                        Text(feed.message)
                            .font(Fonts.caption)
                            .zIndex(20)
                            .foregroundColor(.purple)
                            .padding(.horizontal)
                            .background(.ultraThinMaterial)
                    }
                    .opacity(max(0, 1 - 0.1 * abs(Date().timeIntervalSince1970 - feed.timestamp)))
                }
            }
            .padding(.top, 20)
        }
    }
}
