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
    var lobbyStatus: LobbyStatus

    let roomSetting: RoomSetting
    let modeName: String

    let dataManager: LobbyDataManager
    let lobbyDataChangeHandler: (() -> Void)?

    var playerCount: Int {
        players.count
    }

    var isUserHost: Bool {
        hostId == UserConfig().userId
    }

    var isEligibleToPlay: Bool {
        playerCount >= roomSetting.minPlayerCount && playerCount <= roomSetting.maxPlayerCount
    }

    var isReadyToPlay: Bool {
        true
    }

    private init(lobbyId: String, hostId: String, roomSetting: RoomSetting,
                 modeName: String, players: [String: Player] = [:],
                 lobbyStatus: LobbyStatus = .waitingForPlayers,
                 lobbyDataChangeHandler: (() -> Void)? = { }) {
        self.lobbyId = lobbyId
        self.hostId = hostId
        self.players = players
        self.lobbyStatus = lobbyStatus
        self.lobbyDataChangeHandler = lobbyDataChangeHandler
        self.roomSetting = roomSetting
        self.modeName = modeName
        self.dataManager = LobbyDataManager(databaseAdapter: FirebaseDatabase<Lobby>(),
                                            lobbyDataChangeHandler: lobbyDataChangeHandler)
    }

    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let modeName = try values.decode(String.self, forKey: .modeName)
        self.init(lobbyId: try values.decode(String.self, forKey: .lobbyId),
                  hostId: try values.decode(String.self, forKey: .hostId),
                  roomSetting: ModeFactory.getModeAttachment( modeName).roomSetting,
                  modeName: modeName,
                  lobbyStatus: try values.decode(LobbyStatus.self, forKey: .lobbyStatus))
    }

    /**
     Creates a new lobby and saves it in the database.
     */
    convenience init(modeName: String, lobbyDataChangeHandler: (() -> Void)? = {}) {
        let id = NanoID.new(alphabet: .numbers, size: 6)
        let user = UserConfig()
        let player = Player(playerId: user.userId, name: user.name)
        self.init(lobbyId: id, hostId: user.userId,
                  roomSetting: ModeFactory.getModeAttachment( modeName).roomSetting,
                  modeName: modeName, players: [user.userId: player],
                  lobbyDataChangeHandler: lobbyDataChangeHandler)
        dataManager.createLobby(lobby: self)
    }

    /**
     Joins a lobby with the given `lobbyId`, if it exists.
     */
    convenience init(lobbyId: String, modeName: String, lobbyDataChangeHandler: (() -> Void)? = {}) {
        let user = UserConfig()
        self.init(lobbyId: lobbyId, hostId: user.userId,
                  roomSetting: ModeFactory.getModeAttachment(modeName).roomSetting,
                  modeName: modeName, lobbyDataChangeHandler: lobbyDataChangeHandler)
        let player = Player(playerId: user.userId, name: user.name)
        dataManager.joinLobby(lobby: self, player: player)
    }

    func startMatch() {
        let match = Match(matchId: lobbyId, modeName: modeName)
        dataManager.startMatch(match: match)
    }
}

extension Lobby: Codable {
    private enum CodingKeys: String, CodingKey {
        case lobbyId
        case hostId
        case modeName
        case lobbyStatus
        case players
    }
}

enum LobbyStatus: String, Codable {
    case waitingForPlayers
    case closed
    case matchStarted
    case disconnected
}
