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
                receiver.sliderValue = AudioManager.shared.currentTime(
                    from: String(describing: receiver)) - timeTranslated
                receiver.isEditing = true
                AudioManager.shared.toggleMusic(from: String(describing: receiver))
            },
            completion: { _ in
                AudioManager.shared.seekMusic(to: receiver.sliderValue, from: String(describing: receiver))
                receiver.isEditing = false
                AudioManager.shared.toggleMusic(from: String(describing: receiver))
            }
        )
    }
}
