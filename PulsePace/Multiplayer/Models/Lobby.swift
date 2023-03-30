//
//  Lobby.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

class Lobby {
    var lobbyId: String
    var hostId: String
    var players: [String: Player] = [:]
    var currMatch: Match?

    let config: GameConfig
    let dataManager: LobbyDataManager
    let lobbyDataChangeHandler: (() -> Void)?

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

    private init(lobbyId: String, hostId: String, players: [String: Player] = [:], currMatch: Match? = nil,
                 lobbyDataChangeHandler: (() -> Void)? = { }) {
        self.lobbyId = lobbyId
        self.hostId = hostId
        self.players = players
        self.currMatch = currMatch
        self.lobbyDataChangeHandler = lobbyDataChangeHandler
        self.config = CompetitiveMultiplayerConfig()
        self.dataManager = LobbyDataManager(databaseAdapter: FirebaseDatabase<Lobby>(),
                                            lobbyDataChangeHandler: lobbyDataChangeHandler)
    }

    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init(lobbyId: try values.decode(String.self, forKey: .lobbyId),
                  hostId: try values.decode(String.self, forKey: .hostId))
    }

    /**
     Creates a new lobby and saves it in the database.
     */
    convenience init(lobbyDataChangeHandler: (() -> Void)? = {}) {
        let id = NanoID.new(alphabet: .numbers, size: 6)
        let user = UserConfig()
        let player = Player(playerId: user.userId, name: user.name)
        self.init(lobbyId: id, hostId: user.userId, players: [user.userId: player],
                  lobbyDataChangeHandler: lobbyDataChangeHandler)
        dataManager.createLobby(lobby: self)
    }

    /**
     Joins a lobby with the given `lobbyId`, if it exists.
     */
    convenience init(lobbyId: String, lobbyDataChangeHandler: (() -> Void)? = {}) {
        let user = UserConfig()
        self.init(lobbyId: lobbyId, hostId: "123", lobbyDataChangeHandler: lobbyDataChangeHandler)
        let player = Player(playerId: user.userId, name: user.name)
        dataManager.joinLobby(lobby: self, player: player)
    }
}

extension Lobby: Codable {
    private enum CodingKeys: String, CodingKey {
        case lobbyId
        case hostId
        case players
    }
}
