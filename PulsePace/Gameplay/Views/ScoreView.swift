//
//  ScoreView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 17/3/23.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var gameViewModel: GameViewModel

    @ViewBuilder
    var body: some View {
        VStack(alignment: .trailing) {
            Text(gameViewModel.score)
                .font(Fonts.title)
            // TODO: Accuracy calculation
//            Text(gameViewModel.accuracy)
//                .font(Fonts.title2)
            Text(gameViewModel.combo)
                .font(Fonts.title2)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
