//
//  SlideCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

class SlideCommand: Command {
    convenience init() {
        self.init { _ in
            print("Slide")
        }
    }
}
