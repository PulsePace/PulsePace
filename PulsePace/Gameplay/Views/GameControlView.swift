//
//  PauseControlView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 17/3/23.
//

import SwiftUI

struct GameControlView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State var isPlaying = true

    var body: some View {
        HStack {
            if viewModel.selectedGameMode.requires(gameViewElement: .playbackControls),
               let player = AudioManager.shared.musicPlayers[String(describing: viewModel)] {
                Slider(value: $viewModel.songPosition, in: 0...AudioManager.shared.musicDuration).disabled(true)
                SystemIconButtonView(systemName: isPlaying
                                     ? "pause.circle.fill" : "play.circle.fill", fontSize: 44) {
                    AudioManager.shared.toggleMusic(from: String(describing: viewModel))
                    isPlaying = player.isPlaying
                    viewModel.toggleGameplay()
                }.padding(.all, 20)
            }
        }
    }
}

struct PauseControlView_Previews: PreviewProvider {
    static var previews: some View {
        GameControlView()
    }
}
