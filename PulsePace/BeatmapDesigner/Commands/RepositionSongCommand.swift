//
//  RepositionSongCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

import AVFoundation

class RepositionSongCommand: InputCommand {
    convenience init(receiver: BeatmapDesignerViewModel, player: AVAudioPlayer) {
        self.init(
            action: { inputData in
                receiver.sliderValue = player.currentTime - inputData.translation.width / 2
                receiver.isEditing = true
                player.pause()
            },
            completion: { _ in
                player.currentTime = receiver.sliderValue
                receiver.isEditing = false
                player.play()
            }
        )
    }
}
