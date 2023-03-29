//
//  GameConfig.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

protocol GameConfig {
    var minPlayerCount: Int { get }
    var maxPlayerCount: Int { get }
}

struct CompetitiveMultiplayerConfig: GameConfig {
    var minPlayerCount = 1
    var maxPlayerCount = 4
}
