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
    private var inputManager: InputManager?
    private var conductor: Conductor?

    var gameHOTable: [Entity: any GameHO]
    private var allObjects: Set<Entity>

    var gameEnder: () -> Void
    var match: Match?
    var eventManager = EventManager()
    var systems: [System] = []

    lazy var objRemover: (Entity) -> Void = { [weak self] removedObject in
        guard let self = self else {
            fatalError("No active game engine to remove entities")
        }
        self.allObjects.remove(removedObject)
        guard let removedGameHO = self.gameHOTable.removeValue(forKey: removedObject) else {
            return
        }

        guard let scoreManager = self.scoreSystem?.scoreManager else {
            fatalError("All game engine instances should have a score manager")
        }

        if !removedGameHO.isHit {
            self.eventManager.add(event: MissEvent(gameHO: removedGameHO, timestamp: Date().timeIntervalSince1970))
        }
    }

    lazy var gameHOAdder: (any GameHO) -> Void = { [weak self] gameHO in
        self?.allObjects.insert(gameHO.wrappingObject)
        self?.gameHOTable[gameHO.wrappingObject] = gameHO
    }

    init(modeAttachment: ModeAttachment, gameEnder: @escaping () -> Void, match: Match? = nil) {
        self.allObjects = Set()
        self.gameHOTable = [:]
        self.gameEnder = gameEnder

        if let match = match {
            self.match = match
            eventManager.setMatchEventHandler(matchEventHandler: self)
            matchFeedSystem = MatchFeedSystem(playerNames: match.players)
            if let matchFeedSystem = matchFeedSystem {
                systems.append(matchFeedSystem)
            }
            print("Match id \(match.matchId)")
        } else {
            print("No match attached to engine")
        }

        systems.append(InputSystem())

        modeAttachment.configEngine(self)
        guard let hitObjectManager = hitObjectManager, let scoreSystem = scoreSystem, let evaluator = evaluator else {
            fatalError("Mode attachment should have initialized hit object manager, score system and evaluator")
        }

        systems.append(hitObjectManager)
        systems.append(scoreSystem)
        systems.append(evaluator)
        systems.forEach({ $0.registerEventHandlers(eventManager: self.eventManager) })
    }

    func load(_ beatmap: Beatmap) {
        hitObjectManager?.feedBeatmap(beatmap: beatmap, remover: objRemover)
        self.conductor = Conductor(bpm: beatmap.bpm)
    }

    func step(_ deltaTime: Double) {
        guard let conductor = conductor else {
            print("Cannot advance engine state without conductor")
            return
        }
        conductor.step(deltaTime)
        if let spawnGameHOs = hitObjectManager?.checkBeatMap(conductor.songPosition) {
            spawnGameHOs.forEach { gameHOAdder($0) }
        }

        // Update state of gameHO -> process all inputs on HO
        // -> delegate responses to respective system -> delegate UI display to renderer
        allObjects.forEach { object in
            if let gameHO = gameHOTable[object] {
                gameHO.updateState(currBeat: conductor.songPosition)
            } else {
                print("By game design params, all objects should have a hit object component")
            }
        }
        eventManager.handleAllEvents()

        guard let evaluator = evaluator else {
            fatalError("No active evaluator")
        }

        if evaluator.evaluate() {
            // Stop game
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
