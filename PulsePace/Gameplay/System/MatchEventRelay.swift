//
//  MatchEventRelay.swift
//  PulsePace
//
//  Created by James Chiu on 2/4/23.
//

import Foundation

protocol MatchEventRelay: System {
    var match: Match? { get set }
    var userId: String? { get set }
    var publisher: ((MatchEventMessage) -> Void)? { get set }
}

extension MatchEventRelay {
    func assignProperties(userId: String, publisher: @escaping (MatchEventMessage) -> Void, match: Match) {
        self.match = match
        self.userId = userId
        self.publisher = publisher
    }
}

class CoopMatchEventRelay: MatchEventRelay {
    var match: Match?
    var userId: String?
    var publisher: ((MatchEventMessage) -> Void)?

    func assignProperties(userId: String, publisher: @escaping (MatchEventMessage) -> Void, match: Match) {
        self.userId = userId
        self.publisher = publisher
        self.match = match
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(missEventRelay)
    }

    private lazy var missEventRelay = { [weak self] (_: EventManagable, missEvent: MissEvent) -> Void in
        guard let self = self, let userId = self.userId else {
            fatalError("No active match event relay")
        }
        self.publisher?(MissEvent.makeMessage(event: missEvent, playerId: userId))
    }
}
