//
//  GameEngine.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

class GameEngine {
    var scoreSystem: ScoreSystem?
    var scoreManager: ScoreManager?
    var hitObjectManager: HitObjectManager?
    private var inputManager: InputManager?
    private var conductor: Conductor?

    var gameHOTable: [Entity: any GameHO]
    private var allObjects: Set<Entity>

    var match: Match?
    var eventManager = EventManager()
    private var systems: [System] = []

    lazy var objRemover: (Entity) -> Void = { [weak self] removedObject in
        self?.allObjects.remove(removedObject)
        guard let removedGameHO = self?.gameHOTable.removeValue(forKey: removedObject) else {
            return
        }

        guard let scoreManager = self?.scoreManager else {
            fatalError("All game engine instances should have a score manager")
        }
        if !removedGameHO.isHit {
            scoreManager.missCount += 1
        }
    }

    lazy var gameHOAdder: (any GameHO) -> Void = { [weak self] gameHO in
        self?.allObjects.insert(gameHO.wrappingObject)
        self?.gameHOTable[gameHO.wrappingObject] = gameHO
    }

    init(_ modeAttachment: ModeAttachment) {
        self.allObjects = Set()
        self.gameHOTable = [:]
        self.scoreManager = ScoreManager()

        match = Match(matchId: "051181") // TODO: Remove
        eventManager.setMatchEventHandler(matchEventHandler: self)

        systems.append(InputSystem())
        systems.append(TestSystem())
        systems.append(MatchFeedSystem())

        modeAttachment.configEngine(self)
        guard let hitObjectManager = hitObjectManager, let scoreSystem = scoreSystem,
                let scoreManager = scoreManager else {
            fatalError("Mode attachment should have initialized hit object manager and score system")
        }
        scoreSystem.scoreManager = scoreManager

        systems.append(hitObjectManager)
        systems.append(scoreSystem)
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
