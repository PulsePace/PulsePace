//
//  LivesCountView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/4/23.
//

import SwiftUI

struct LivesCountView: View {
    @EnvironmentObject var gameVM: GameViewModel

    var body: some View {
        if gameVM.selectedGameMode.requires(gameViewElement: .livesCount) {
            HStack {
                ForEach(0 ..< gameVM.livesCount, id: \.self) { _ in
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                        .padding(5)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
