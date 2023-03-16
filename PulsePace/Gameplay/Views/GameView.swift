//
//  GameView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @EnvironmentObject var audioManager: AudioManager

    var body: some View {
        VStack {
            HStack {
                Text(gameViewModel.score)
                    .font(.largeTitle)
            }

            GameplayAreaView()
        }
        .fullBackground(imageName: gameViewModel.gameBackground)
    }

    @ViewBuilder
    private func renderPlaybackButtons() -> some View {
        if let player = audioManager.player {
            HStack {
                PlaybackControlButtonView(systemName: player.isPlaying
                                     ? "pause.circle.fill" : "play.circle.fill", fontSize: 44) {
                    audioManager.togglePlayer()
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameViewModel: GameViewModel())
    }
}
