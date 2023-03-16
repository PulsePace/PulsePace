//
//  AddTapHitObjectCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

class AddTapHitObjectCommand: InputCommand {
    override private init(action: @escaping InputCommand.Action, completion: InputCommand.Action? = nil) {
        super.init(action: action, completion: completion)
    }

    convenience init(receiver: BeatmapDesignerViewModel) {
        self.init(action: { inputData in
            let interval = 1 / (receiver.bps * receiver.divisor)
            let beat = ((receiver.sliderValue - receiver.offset) / interval).rounded()
            receiver.hitObjects.enqueue(TapHitObject(position: inputData.location, beat: beat * interval))
        })
    }
}
