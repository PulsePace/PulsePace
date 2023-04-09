//
//  Player.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

import Foundation

struct Player {
    let playerId: String
    var name: String
    var isReady = false

    init(playerId: String, name: String, isReady: Bool = false) {
        self.playerId = playerId
        self.name = name
        self.isReady = isReady
    }
}

extension Player: Codable {}

extension Player: Hashable {}
