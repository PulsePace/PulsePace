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
        let andEventsSatisfied = andEventCount.keys.allSatisfy {
            guard let eventCount = andEventCount[$0], let eventTargetCount = andEventCriterias[$0] else {
                fatalError("Evaluator not initialized correctly")
            }
            return eventCount >= eventTargetCount
        } || andEventCriterias.isEmpty

        if !andEventsSatisfied {
            return false
        }

        let orEventsSatisfied = orEventCount.keys.contains(where: {
            guard let eventCount = orEventCount[$0], let eventTargetCount = orEventCriterias[$0] else {
                fatalError("Evaluator not initialized correctly")
            }
            return eventCount >= eventTargetCount
        }) || orEventCriterias.isEmpty

        return andEventsSatisfied && orEventsSatisfied
    }

    func reset() {
        andEventCount.keys.forEach { andEventCount[$0] = 0 }
        orEventCount.keys.forEach { orEventCount[$0] = 0 }
    }
}

class DefaultEvaluator: Evaluator {
    let andEventCriterias = [LastHitObjectRemovedEvent.label: 1]
    let orEventCriterias: [String: Int] = [:]
    var andEventCount: [String: Int] = [:]
    var orEventCount: [String: Int] = [:]

    init() {
        andEventCount[LastHitObjectRemovedEvent.label] = 0
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(markLastObjectRemovedHandler)
    }

    private lazy var markLastObjectRemovedHandler
    = { [weak self] (_: EventManagable, _: LastHitObjectRemovedEvent) -> Void in
        guard let self = self else {
            fatalError("No active evaluator")
        }

        guard let targetEventCount = self.andEventCount[LastHitObjectRemovedEvent.label] else {
            fatalError("\(LastHitObjectRemovedEvent.label) not found in evaluator ledger")
        }
        self.andEventCount[LastHitObjectRemovedEvent.label] = targetEventCount + 1
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

class CompetitiveEvaluator: Evaluator {
    let andEventCriterias: [String: Int] = [:]
    let orEventCriterias = [SelfDeathEvent.label: 1,
                            LastHitObjectRemovedEvent.label: 1,
                            OnlyRemainingPlayerEvent.label: 1]
    var andEventCount: [String: Int] = [:]
    var orEventCount: [String: Int] = [:]

    init() {
        orEventCount[SelfDeathEvent.label] = 0
        orEventCount[LastHitObjectRemovedEvent.label] = 0
        orEventCount[OnlyRemainingPlayerEvent.label] = 0
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(markSelfDeathHandler)
        eventManager.registerHandler(markLastObjectRemovedHandler)
        eventManager.registerHandler(markOnlyRemainingPlayerHandler)
    }

    private lazy var markSelfDeathHandler = { [weak self] (_: EventManagable, _: SelfDeathEvent) -> Void in
        guard let self = self else {
            fatalError("No active evaluator")
        }

        guard let targetEventCount = self.orEventCount[SelfDeathEvent.label] else {
            fatalError("\(SelfDeathEvent.label) not found in evaluator ledger")
        }
        self.orEventCount[SelfDeathEvent.label] = targetEventCount + 1
    }

    private lazy var markLastObjectRemovedHandler
    = { [weak self] (_: EventManagable, _: LastHitObjectRemovedEvent) -> Void in
        guard let self = self else {
            fatalError("No active evaluator")
        }

        guard let targetEventCount = self.orEventCount[LastHitObjectRemovedEvent.label] else {
            fatalError("\(LastHitObjectRemovedEvent.label) not found in evaluator ledger")
        }
        self.orEventCount[LastHitObjectRemovedEvent.label] = targetEventCount + 1
    }

    private lazy var markOnlyRemainingPlayerHandler
    = { [weak self] (_: EventManagable, _: OnlyRemainingPlayerEvent) -> Void in
        guard let self = self else {
            fatalError("No active evaluator")
        }

        guard let targetEventCount = self.orEventCount[OnlyRemainingPlayerEvent.label] else {
            fatalError("\(OnlyRemainingPlayerEvent.label) not found in evaluator ledger")
        }
        self.orEventCount[OnlyRemainingPlayerEvent.label] = targetEventCount + 1
    }
}

class InfiniteEvaluator: Evaluator {
    let andEventCriterias = [SelfDeathEvent.label: 1]
    let orEventCriterias: [String: Int] = [:]
    var andEventCount: [String: Int] = [:]
    var orEventCount: [String: Int] = [:]

    init() {
        andEventCount[SelfDeathEvent.label] = 0
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(markSelfDeathHandler)
    }

    private lazy var markSelfDeathHandler = { [weak self] (_: EventManagable, _: SelfDeathEvent) -> Void in
        guard let self = self else {
            fatalError("No active evaluator")
        }

        guard let targetEventCount = self.andEventCount[SelfDeathEvent.label] else {
            fatalError("\(SelfDeathEvent.label) not found in evaluator ledger")
        }
        self.andEventCount[SelfDeathEvent.label] = targetEventCount + 1
    }
}
