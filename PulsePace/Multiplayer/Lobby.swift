//
//  Lobby.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

struct Lobby {
    var hostId: String
    var players: [Player] = []
    var currMatch: Match?
    let config: GameConfig
    
    var playerCount: Int {
        players.count
    }
    
    var isUserLobbyHost: Bool {
        hostId == UserConfig().id
    }
    
    var isLobbyEligibleToPlay: Bool {
        playerCount > config.minPlayerCount && playerCount <= config.maxPlayerCount
    }
    
    var isLobbyReadyToPlay: Bool {
        true
    }
}
