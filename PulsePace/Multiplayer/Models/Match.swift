//
//  Match.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

class Match {
    let matchId: String
    let dataManager: MatchDataManager

    init(matchId: String) {
        self.matchId = matchId
        self.dataManager = MatchDataManager(publisher: FirebaseDatabase<MatchEventMessage>(),
                                            subscriber: FirebaseListener<MatchEventMessage>(),
                                            matchId: matchId)
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
