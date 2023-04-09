//
//  ScoreView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 17/3/23.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var gameVM: GameViewModel

    @ViewBuilder
    var body: some View {
        if gameVM.selectedGameMode.requires(gameViewElement: .scoreBoard) {
            VStack(alignment: .trailing) {
                Text(gameVM.score)
                    .font(Fonts.title)
                // TODO: Accuracy calculation
                //            Text(gameVM.accuracy)
                //                .font(Fonts.title2)
                Text(gameVM.combo)
                    .font(Fonts.title2)
            }
            .foregroundColor(.white)
            .padding(20)
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
