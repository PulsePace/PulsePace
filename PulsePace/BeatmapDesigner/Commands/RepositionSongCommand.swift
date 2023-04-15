//
//  RepositionSongCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

import AVFoundation

class RepositionSongCommand: InputCommand {
    override private init(action: @escaping InputCommand.Action, completion: InputCommand.Action? = nil) {
        super.init(action: action, completion: completion)
    }

    convenience init(receiver: BeatmapDesignerViewModel, player: AVAudioPlayer) {
        self.init(
            action: { inputData in
                let timeTranslated = inputData.translation.width / receiver.zoom
                receiver.sliderValue = player.currentTime - timeTranslated
                receiver.isEditing = true
                player.pause()
            },
            completion: { _ in
                player.currentTime = receiver.sliderValue
                receiver.isEditing = false
            }
        )
    }
}
