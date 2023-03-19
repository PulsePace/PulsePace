//
//  SlideCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//
import simd

class SlideCommand: InputCommand {
    override private init(action: @escaping InputCommand.Action, completion: InputCommand.Action? = nil) {
        super.init(action: action, completion: completion)
    }

    convenience init(receiver: SlideGameHO) {
        self.init(
            action: { _ in
                print("Slide")
//                receiver.checkOnInput(inputData: inputData)
            },
            completion: { _ in
//                receiver.checkOnInputEnd(inputData: inputData)
            }
        )
    }
}
