//
//  TapCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

class TapCommand: Command {
    convenience init() {
        self.init { _ in
            print("Tap")
        }
    }
}
