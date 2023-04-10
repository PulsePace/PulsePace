//
//  MatchEventRelay.swift
//  PulsePace
//
//  Created by James Chiu on 2/4/23.
//

import Foundation

protocol MatchEventRelay: ModeSystem {
    var match: Match? { get set }
    var userId: String { get }
    var publisher: ((MatchEventMessage) -> Void)? { get set }
}

extension MatchEventRelay {
    func assignProperties(publisher: @escaping (MatchEventMessage) -> Void, match: Match) {
        self.match = match
        self.publisher = publisher
    }

    func reset() {
        match = nil
        publisher = nil
    }
}

class CoopMatchEventRelay: MatchEventRelay {
    var match: Match?
    let userId: String
    var publisher: ((MatchEventMessage) -> Void)?

    init() {
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        self.userId = userConfigManager.userId
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(missEventRelay)
    }

    private lazy var missEventRelay = { [weak self] (_: EventManagable, missEvent: MissEvent) -> Void in
        guard let self = self else {
            fatalError("No active match event relay")
        }
        guard let matchEventMessage = MissEvent.makeMessage(event: missEvent, playerId: self.userId) else {
            return
        }
        self.publisher?(matchEventMessage)
    }

    private lazy var gameCompleteEventRelay = { [weak self] (_: EventManagable, gameCompleteEvent: GameCompleteEvent) -> Void in
        guard let self = self else {
            fatalError("No active match event relay")
        }

        guard let matchEventMessage = GameCompleteEvent.makeMessage(event: gameCompleteEvent, playerId: userId) else {
            return
        }
        self.publisher?(matchEventMessage)
    }
}

class CompetitiveMatchEventRelay: MatchEventRelay {
    var match: Match?
    let userId: String
    var publisher: ((MatchEventMessage) -> Void)?

    init() {
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        self.userId = userConfigManager.userId
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(otherRelay)
    }

    private lazy var otherRelay = { [weak self] (_: EventManagable, _: DeathEvent) -> Void in
        guard let self = self else {
            fatalError("No active match event relay")
        }
        print(self.publisher ?? "") // TODO: MatchEvents - `makeMessage()` can be done by the other system
    }
}
