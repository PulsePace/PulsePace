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

// Coop limited to two player
struct PublishMissTapEvent: MatchEvent {
    var timestamp: Double
    var tapHO: SerializedTapHO
    var destinationId: String
}

struct PublishMissSlideEvent: MatchEvent {
    var timestamp: Double
    var slideHO: SerializedSlideHO
    var destinationId: String
}

struct PublishMissHoldEvent: MatchEvent {
    var timestamp: Double
    var holdHO: SerializedHoldHO
    var destinationId: String
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
    var bombSourcePlayerId: String
    var bombTargetPlayerId: String
}

struct SpawnHOEvent: Event {
    var timestamp = 0.0
    var hitObject: any HitObject
}

struct TestEvent: Event {
    var timestamp: Double
    var player: Player
}

// Systems
class MatchFeedSystem: System {
    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(announceFeedHandler)
    }

    private lazy var announceFeedHandler = { (_: EventManagable, event: AnnounceFeedEvent) -> Void in
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
