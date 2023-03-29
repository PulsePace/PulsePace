//
//  GameEngine.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

class GameEngine {
    var scoreManager: ScoreManager
    private var allObjects: Set<Entity>
    var gameHOTable: [Entity: any GameHO]
    private var inputManager: InputManager?
    private var hitObjectManager: HitObjectManager?
    private var conductor: Conductor?
    var eventManager = EventManager()
    private var systems: [System] = []

    lazy var objRemover: (Entity) -> Void = { [weak self] removedObject in
        self?.allObjects.remove(removedObject)
        guard let removedGameHO = self?.gameHOTable.removeValue(forKey: removedObject) else {
            return
        }
        if !removedGameHO.isHit {
            self?.scoreManager.missCount += 1
        }
    }

    lazy var gameHOAdder: (any GameHO) -> Void = { [weak self] gameHO in
        self?.allObjects.insert(gameHO.wrappingObject)
        self?.gameHOTable[gameHO.wrappingObject] = gameHO
    }

    init() {
        self.allObjects = Set()
        self.gameHOTable = [:]
        self.scoreManager = ScoreManager()
        self.systems.append(ScoreSystem(scoreManager: scoreManager))
        self.systems.append(InputSystem())
        self.systems.forEach({ $0.registerEventHandlers(eventManager: self.eventManager) })
    }

    func load(_ beatmap: Beatmap) {
        reset()
        self.hitObjectManager = HitObjectManager(
            hitObjects: beatmap.hitObjects,
            preSpawnInterval: beatmap.preSpawnInterval,
            remover: objRemover,
            offset: beatmap.offset,
            slideSpeed: beatmap.sliderSpeed
        )
        self.conductor = Conductor(bpm: beatmap.bpm)
        self.inputManager = InputManager()
//        inputManager.addHandler(scoreManager)
    }

    func reset() {
        self.allObjects.removeAll()
        self.gameHOTable.removeAll()
        self.hitObjectManager = nil
        self.inputManager = nil
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
