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

    convenience init(receiver: BeatmapDesignerViewModel) {
        self.init(
            action: { inputData in
                let timeTranslated = inputData.translation.width / receiver.zoom
                receiver.sliderValue = AudioManager.shared.currentTime() - timeTranslated
                receiver.isEditing = true
                AudioManager.shared.musicPlayer?.pause()
            },
            completion: { _ in
                AudioManager.shared.seekMusic(to: receiver.sliderValue)
                receiver.isEditing = false
                AudioManager.shared.musicPlayer?.play()
            }
        )
    }
}
