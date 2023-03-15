//
//  AddTapHitObjectCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

class AddTapHitObjectCommand: InputCommand {
    convenience init(receiver: BeatmapDesignerViewModel) {
        self.init { inputData in
            receiver.hitObjects.append(TapHitObject(position: inputData.location, beat: receiver.sliderValue))
            print("Tap Hit Object at \(inputData.location)")
        }
    }
}
