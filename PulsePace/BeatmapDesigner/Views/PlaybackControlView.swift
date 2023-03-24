//
//  PlaybackControlView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/15.
//

import SwiftUI

struct PlaybackControlView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel

    var body: some View {
        HStack {
            renderPlaybackProgressSlider()
            renderPlaybackButtons()
            renderPlaybackRateButtons()
        }
        .zIndex(.infinity)
    }

    @ViewBuilder
    private func renderPlaybackProgressSlider() -> some View {
        if let player = audioManager.player {
            Slider(value: $beatmapDesigner.sliderValue, in: 0...player.duration) { editing in
                beatmapDesigner.isEditing = editing
                if editing {
                    player.pause()
                } else {
                    player.play()
                    player.currentTime = beatmapDesigner.sliderValue
                }
            }
        }
    }

    @ViewBuilder
    private func renderPlaybackButtons() -> some View {
        if let player = audioManager.player {
            HStack {
                let iconSystemName = player.isPlaying ? "pause.circle.fill" : "play.circle.fill"
                SystemIconButtonView(systemName: iconSystemName, fontSize: 44) {
                    audioManager.togglePlayer()
                }
            }
        }
    }

    @ViewBuilder
    private func renderPlaybackRateButtons() -> some View {
        VStack {
            SystemIconButtonView(systemName: "plus.circle.fill") {
                audioManager.increasePlaybackRate()
            }
            SystemIconButtonView(systemName: "minus.circle.fill") {
                audioManager.decreasePlaybackRate()
            }
        }
    }
}

struct PlaybackControlView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackControlView()
    }
}
