//
//  MatchEvent.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

import Foundation

// NOTE: Assumes one to one relationship between match event and handler
protocol MatchEvent: Codable {
    associatedtype MessageHandlerType: MessageHandler
    var timestamp: Double { get }
}

extension MatchEvent {
    static var getType: MessageHandlerType.Type {
        MessageHandlerType.self
    }
}

// Coop limited to two player
struct PublishMissTapEvent: MatchEvent {
    typealias MessageHandlerType = MissTapMessageDecoder
    var timestamp: Double
    var tapHO: SerializedTapHO
    var sourceId: String
}

struct PublishMissSlideEvent: MatchEvent {
    typealias MessageHandlerType = MissSlideMessageDecoder
    var timestamp: Double
    var slideHO: SerializedSlideHO
    var sourceId: String
}

struct PublishMissHoldEvent: MatchEvent {
    typealias MessageHandlerType = MissHoldMessageDecoder
    var timestamp: Double
    var holdHO: SerializedHoldHO
    var sourceId: String
}

struct PublishBombDisruptorEvent: MatchEvent {
    typealias MessageHandlerType = BombDisruptorMessageDecoder
    var timestamp: Double
    var destinationIds: [String]
}

struct SampleEvent: MatchEvent {
    typealias MessageHandlerType = SampleMessageDecoder
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
