//
//  TapCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

class TapCommand: InputCommand {
    convenience init() {
        self.init { inputData in
            print("Tap at \(inputData.location)")
        }
    }
}
