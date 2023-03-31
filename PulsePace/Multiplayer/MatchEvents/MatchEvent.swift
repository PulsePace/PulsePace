//
//  MatchEvent.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

import Foundation

protocol MatchEvent: Codable {
    var timestamp: Double { get }
}

struct PublishBombDisruptorEvent: MatchEvent {
    var timestamp: Double
    var destinationIds: [String]
}

struct SampleEvent: MatchEvent {
    var timestamp: Double
    var sampleData: String
}

// FOR TESTING
// Events
struct SpawnBombDisruptorEvent: Event {
    var timestamp: Double
}

struct TestEvent: Event {
    var timestamp: Double
    var player: Player
}

struct AnnounceFeedEvent: Event {
    var timestamp: Double
    var message: String
}

// Systems
class MatchFeedSystem: System {
    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(announceFeedHandler)
    }

    private lazy var announceFeedHandler = { [self] (_: EventManagable, event: AnnounceFeedEvent) -> Void in
        print(event.message)
    }
}

class TestSystem: System {
    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(testEventHandler)
    }

    private lazy var testEventHandler = { [self] (eventManager: EventManagable, _: TestEvent) -> Void in
        eventManager.matchEventHandler?.publishMatchEvent(message: MatchEventMessage(
            timestamp: Date().timeIntervalSince1970, sourceId: UserConfig().userId,
            event: PublishBombDisruptorEvent(timestamp: Date().timeIntervalSince1970,
                                             destinationIds: ["123", "456"])))
    }
}