//
//  AddTapHitObjectCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

class AddTapHitObjectCommand: InputCommand {
    convenience init(receiver: BeatmapDesignerViewModel) {
        self.init(action: { inputData in
            let interval = 1 / (receiver.bps * receiver.divisor)
            let beat = ((receiver.sliderValue - receiver.offset) / interval).rounded()
            receiver.hitObjects.enqueue(TapHitObject(position: inputData.location, beat: beat * interval))
        })
    }
}
