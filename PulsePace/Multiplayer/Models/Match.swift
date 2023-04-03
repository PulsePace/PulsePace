//
//  Match.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

class Match {
    let matchId: String
    let modeName: String
    let dataManager: MatchDataManager
    let players: [String: String]

    init(matchId: String, lobby: Lobby? = nil) {
        self.matchId = matchId
        self.modeName = lobby?.modeName ?? ModeFactory.defaultMode.modeName
        self.dataManager = MatchDataManager(publisher: FirebaseDatabase<MatchEventMessage>(),
                                            subscriber: FirebaseListener<MatchEventMessage>(),
                                            matchId: matchId,
                                            matchEventTypes: ModeFactory.getModeAttachment(modeName).listeningMatchEvents)
        self.players = lobby?.players.mapValues { player in
            player.name
        } ?? [:]
    }

    convenience init(_ lobby: Lobby) {
        self.init(matchId: lobby.lobbyId, lobby: lobby)
    }

    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init(matchId: try values.decode(String.self, forKey: .matchId))
    }
}

extension Match: Codable {
    private enum CodingKeys: String, CodingKey {
        case matchId
    }
}
