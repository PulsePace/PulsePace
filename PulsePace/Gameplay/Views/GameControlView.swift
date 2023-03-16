//
//  PauseControlView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 17/3/23.
//

import SwiftUI

struct GameControlView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State var isPlaying = true

    var body: some View {
        if let player = audioManager.player {
            SystemIconButtonView(systemName: isPlaying
                                 ? "pause.circle.fill" : "play.circle.fill", fontSize: 44) {
                audioManager.togglePlayer()
                isPlaying = player.isPlaying
            }
        }
    }
}

struct PauseControlView_Previews: PreviewProvider {
    static var previews: some View {
        GameControlView()
    }
}
