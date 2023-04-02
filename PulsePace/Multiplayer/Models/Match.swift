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

    init(matchId: String, modeName: String) {
        self.matchId = matchId
        self.modeName = modeName
        self.dataManager = MatchDataManager(publisher: FirebaseDatabase<MatchEventMessage>(),
                                            subscriber: FirebaseListener<MatchEventMessage>(),
                                            matchId: matchId, matchEventTypes: ModeFactory.getModeAttachment(modeName).listeningMatchEvents)
    }

    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init(matchId: try values.decode(String.self, forKey: .matchId), modeName: try values.decode(String.self, forKey: .modeName))
    }
}

extension Match: Codable {
    private enum CodingKeys: String, CodingKey {
        case matchId
        case modeName
    }
}
