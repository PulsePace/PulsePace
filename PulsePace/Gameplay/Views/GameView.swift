//
//  GameView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @EnvironmentObject var audioManager: AudioManager

    init(viewModel: GameViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            GameplayAreaView()
            .overlay(alignment: .topTrailing) {
                ScoreView()
            }
            .overlay(alignment: .top) {
                GameControlView()
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .onAppear {
            audioManager.startPlayer(track: "test")
            viewModel.startGameplay()
        }
        .onDisappear {
            audioManager.stopPlayer()
            viewModel.stopGameplay()
        }
        .environmentObject(viewModel)
        .fullBackground(imageName: viewModel.gameBackground)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
