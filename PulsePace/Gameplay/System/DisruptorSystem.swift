//
//  DisruptorSystem.swift
//  PulsePace
//
//  Created by Charisma Kausar on 2/4/23.
//

import Foundation

class DisruptorSystem: ScoreSystem {
    var selectedTarget = UserConfig().userId
    var selectedDisruptor: Disruptor = .noHints
    var isEligibileToSendDisruptor: Bool {
        guard let scoreManager = scoreManager else {
            return false
        }
        return scoreManager.comboCount > 0 && scoreManager.comboCount.isMultiple(of: 5)
    }

    func setDisruptor(disruptor: Disruptor) {
        self.selectedDisruptor = disruptor
    }

    func setTarget(targetId: String) {
        self.selectedTarget = targetId
    }

    override func registerEventHandlers(eventManager: EventManagable) {
        super.registerEventHandlers(eventManager: eventManager)
        eventManager.registerHandler(updateComboHandler)
    }

    lazy var updateComboHandler = { [self] (eventManager: EventManagable, event: UpdateComboEvent) -> Void in
        guard isEligibileToSendDisruptor else {
            return
        }
        eventManager.matchEventHandler?.publishMatchEvent(message: MatchEventMessage(
            timestamp: Date().timeIntervalSince1970, sourceId: UserConfig().userId,
            event: PublishDisruptorFactory().getPublishEvent(disruptor: selectedDisruptor,
                                                             targetId: selectedTarget,
                                                             location: event.lastLocation
                                                            )))
    }
}

class PublishDisruptorFactory {
    func getPublishEvent(disruptor: Disruptor, targetId: String, location: CGPoint) -> MatchEvent {
        if disruptor == .bomb {
            return PublishBombDisruptorEvent(timestamp: Date().timeIntervalSince1970,
                                             bombTargetId: targetId,
                                             bombLocation: location)
        } else if disruptor == .noHints {
            return PublishNoHintsDisruptorEvent(timestamp: Date().timeIntervalSince1970,
                                                noHintsTargetId: targetId,
                                                preSpawnInterval: 0.4,
                                                duration: 10)
        }
        fatalError("Specified disruptor does not exist")
    }
}

enum Disruptor: String {
    case noHints
    case bomb
}
