//
//  Evaluator.swift
//  PulsePace
//
//  Created by James Chiu on 9/4/23.
//

import Foundation

protocol Evaluator: ModeSystem {
    var andEventCriterias: [String: Int] { get }
    var orEventCriterias: [String: Int] { get }
    // All must be satisfied to evaluate to true
    var andEventCount: [String: Int] { get set }
    // One is satisfied then evaluates to true
    var orEventCount: [String: Int] { get set }
}

extension Evaluator {
    // Determines whether game should end
    func evaluate() -> Bool {
        var andEventsSatisfied = andEventCount.keys.allSatisfy {
            guard let eventCount = andEventCount[$0], let eventTargetCount = andEventCriterias[$0] else {
                fatalError("Evaluator not initialized correctly")
            }
            return eventCount >= eventTargetCount
        } || andEventCriterias.isEmpty

        if !andEventsSatisfied {
            return false
        }

        var orEventsSatisfied = orEventCount.keys.contains(where: {
            guard let eventCount = orEventCount[$0], let eventTargetCount = orEventCriterias[$0] else {
                fatalError("Evaluator not initialized correctly")
            }
            return eventCount >= eventTargetCount
        }) || orEventCriterias.isEmpty

        return andEventsSatisfied && orEventsSatisfied
    }

    func reset() {
        andEventCount.keys.forEach { andEventCount[$0] = 0 }
        orEventCount.keys.forEach { andEventCount[$0] = 0 }
    }
}

class DefaultEvaluator: Evaluator {
    let andEventCriterias = [LastHitobjectRemovedEvent.label: 1]
    let orEventCriterias: [String: Int] = [:]
    var andEventCount: [String: Int] = [:]
    var orEventCount: [String: Int] = [:]

    init() {
        andEventCount[LastHitobjectRemovedEvent.label] = 0
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(markLastObjectRemovedHandler)
    }

    private lazy var markLastObjectRemovedHandler = { [weak self] (_: EventManagable, _: LastHitobjectRemovedEvent) -> Void in
        guard let self = self else {
            fatalError("No active evaluator")
        }

        guard let targetEventCount = self.andEventCount[LastHitobjectRemovedEvent.label] else {
            fatalError("\(LastHitobjectRemovedEvent.label) not found in evaluator ledger")
        }
        self.andEventCount[LastHitobjectRemovedEvent.label] = targetEventCount + 1
    }
}

class CoopEvaluator: Evaluator {
    let andEventCriterias = [GameCompleteEvent.label: 2]
    let orEventCriterias: [String: Int] = [:]
    var andEventCount: [String: Int] = [:]
    var orEventCount: [String: Int] = [:]

    init() {
        andEventCount[GameCompleteEvent.label] = 0
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(markGameCompleteHandler)
    }

    private lazy var markGameCompleteHandler = { [weak self] (_: EventManagable, _: GameCompleteEvent) -> Void in
        guard let self = self else {
            fatalError("No active evaluator")
        }

        guard let targetEventCount = self.andEventCount[GameCompleteEvent.label] else {
            fatalError("\(GameCompleteEvent.label) not found in evaluator ledger")
        }
        self.andEventCount[GameCompleteEvent.label] = targetEventCount + 1
    }
}
