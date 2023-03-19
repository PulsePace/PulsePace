//
//  PauseControlView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 17/3/23.
//

import SwiftUI

struct GameControlView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var viewModel: GameViewModel
    @State var isPlaying = true

    var body: some View {
        HStack {
            if let player = audioManager.player {
                Slider(value: $viewModel.songPosition, in: 0...player.duration).disabled(true)
                SystemIconButtonView(systemName: isPlaying
                                     ? "pause.circle.fill" : "play.circle.fill", fontSize: 44) {
                    audioManager.togglePlayer()
                    isPlaying = player.isPlaying
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
