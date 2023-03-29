//
//  Lobby.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

import Foundation

class Lobby {
    var lobbyId: String
    var hostId: String
    var players: [Player] = []
    var currMatch: Match?

    let config: GameConfig
    let dataManager: LobbyDataManager

    var playerCount: Int {
        players.count
    }

    var isUserLobbyHost: Bool {
        hostId == UserConfig().userId
    }

    var isLobbyEligibleToPlay: Bool {
        playerCount > config.minPlayerCount && playerCount <= config.maxPlayerCount
    }

    var isLobbyReadyToPlay: Bool {
        true
    }

    init(lobbyId: String, hostId: String, players: [Player] = [], currMatch: Match? = nil) {
        self.lobbyId = lobbyId
        self.hostId = hostId
        self.players = players
        self.currMatch = currMatch
        self.config = CompetitiveMultiplayerConfig()
        self.dataManager = LobbyDataManager(databaseAdapter: FirebaseDatabase<Lobby>())
    }

    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init(lobbyId: try values.decode(String.self, forKey: .lobbyId),
                  hostId: try values.decode(String.self, forKey: .hostId),
                  players: try values.decode([Player].self, forKey: .players),
                  currMatch: try values.decode(Match.self, forKey: .currMatch))
    }

    convenience init() {
        self.init(lobbyId: UUID().uuidString, hostId: UserConfig().userId)
        dataManager.createLobby(lobby: self)
    }

    convenience init(lobbyId: String) {
        let user = UserConfig()
        self.init(lobbyId: lobbyId, hostId: user.userId)
        let player = Player(playerId: user.userId, name: user.name)
        dataManager.joinLobby(lobbyId: lobbyId, player: player)
    }
}

extension Lobby: Codable {
    private enum CodingKeys: String, CodingKey {
        case lobbyId
        case hostId
        case players
        case currMatch
    }
}
