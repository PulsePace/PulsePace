//
//  GameEngine.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

class GameEngine {
    var scoreSystem: ScoreSystem?
    var scoreManager: ScoreManager {
        guard let scoreSystem = scoreSystem else {
            fatalError("Score system has no score manager")
        }
        return scoreSystem.scoreManager
    }

    var hitObjectManager: HitObjectManager?
    var matchFeedSystem: MatchFeedSystem?
    var evaluator: Evaluator?
    var gameEnder: () -> Void
    private var inputManager: InputManager?
    var conductor: Conductor?

    var match: Match?
    var eventManager = EventManager()
    var systems: [System] = []

    init(modeAttachment: ModeAttachment, gameEnder: @escaping () -> Void, match: Match? = nil) {
        self.gameEnder = gameEnder
        if let match = match {
            self.match = match
            eventManager.setMatchEventHandler(matchEventHandler: self)
            matchFeedSystem = MatchFeedSystem(playerNames: match.players)
            if let matchFeedSystem = matchFeedSystem {
                systems.append(matchFeedSystem)
            }
        }

        modeAttachment.configEngine(self)
        guard let hitObjectManager = hitObjectManager, let scoreSystem = scoreSystem,
              let evaluator = evaluator, let conductor = conductor else {
            fatalError("Mode attachment should have initialized hit object manager, score system and evaluator")
        }
        systems.append(InputSystem())
        systems.append(hitObjectManager)
        systems.append(scoreSystem)
        systems.append(evaluator)
        systems.append(conductor)
        systems.forEach { $0.registerEventHandlers(eventManager: self.eventManager) }
    }

    func load(_ beatmap: Beatmap) {
        hitObjectManager?.feedBeatmap(beatmap: beatmap)
        conductor?.feedBeatmap(beatmap: beatmap)
    }

    func step(_ deltaTime: Double) {
        guard let conductor = conductor else {
            print("Cannot advance engine state without conductor")
            return
        }
        systems.forEach({ $0.step(deltaTime: deltaTime, songPosition: conductor.songPosition) })
        eventManager.handleAllEvents()

        guard let evaluator = evaluator else {
            fatalError("No active evaluator")
        }

        if evaluator.evaluate() {
            gameEnder()
        }
    }

    func setTarget(targetId: String) {
        guard let disruptorSystem = scoreSystem as? DisruptorSystem else {
           return
        }
        disruptorSystem.setTarget(targetId: targetId)
    }

    func setDisruptor(disruptor: Disruptor) {
        guard let disruptorSystem = scoreSystem as? DisruptorSystem else {
           return
        }
        disruptorSystem.setDisruptor(disruptor: disruptor)
    }
}

extension GameEngine: MatchEventHandler {
    func publishMatchEvent(message: MatchEventMessage) {
        match?.dataManager.publishEvent(matchEvent: message)
    }

    func subscribeMatchEvents() {
        match?.dataManager.subscribeEvents(eventManager: eventManager)
    }
}

protocol MatchEventHandler: AnyObject {
    func publishMatchEvent(message: MatchEventMessage)
    func subscribeMatchEvents()
}
