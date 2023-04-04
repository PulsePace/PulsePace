//
//  MatchEventMessage.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

import Foundation

class MatchEventMessage: Codable {
    var timestamp: Double
    var sourceId: String
    var encodedEvent: String

    init(timestamp: Double, sourceId: String, encodedEvent: String) {
        self.timestamp = timestamp
        self.sourceId = sourceId
        self.encodedEvent = encodedEvent
    }

    convenience init(timestamp: Double, sourceId: String, event: some MatchEvent) {
        let encodedEvent: String
        do {
            encodedEvent = try JSONEncoder().encode(event).base64EncodedString()
            self.init(timestamp: timestamp, sourceId: sourceId, encodedEvent: encodedEvent)
        } catch {
            fatalError("Could not encode match event message")
        }
    }
}
