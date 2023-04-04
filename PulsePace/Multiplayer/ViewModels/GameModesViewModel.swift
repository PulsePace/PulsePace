//
//  GameModesViewModel.swift
//  PulsePace
//
//  Created by Charisma Kausar on 30/3/23.
//

import Foundation

class GameModesViewModel: ObservableObject {
    var gameModes: [GameMode] = ModeFactory.getAllModes()
}
