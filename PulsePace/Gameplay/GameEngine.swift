//
//  GameEngine.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

// TODO: Add conductor
class GameEngine {
    var conductor: Conductor
    var scoreManager: ScoreManager
    var allObjects: Set<Entity>
    var gameHOTable: [Entity: any GameHO]
    var hitObjectManager: HitObjectManager?

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
        // TODO: Should load from beatmap
        self.conductor = Conductor(songPosition: 0, bpm: 0)
        self.scoreManager = ScoreManager()
    }

    // TODO: Should load from beatmap data structure
    func load(_ beatMap: [any HitObject]) {
        self.hitObjectManager = HitObjectManager(
            hitObjects: beatMap,
            preSpawnInterval: 0,
            remover: objRemover,
            slideSpeed: 100
        )
    }

    func reset() {
        self.allObjects.removeAll()
        self.gameHOTable.removeAll()
        self.hitObjectManager = nil
    }

    func step(_ deltaTime: Double) {
        let currBeat = conductor.currBeat
        if let spawnGameHOs = hitObjectManager?.checkBeatMap(currBeat) {
            spawnGameHOs.forEach { gameHOAdder($0) }
        }

        // Should contain all hitobjects that have been "touched" this frame
        var engagedHOs: [any GameHO] = []
        /// Update state of gameHO -> process all inputs on HO
        /// -> delegate responses to respective system -> delegate UI display to renderer
        allObjects.forEach { object in
            if let gameHO = gameHOTable[object] {
                gameHO.updateState(currBeat: currBeat)
                if gameHO.shouldExecute {
                    engagedHOs.append(gameHO)
                }
            } else {
                print("By game design params, all objects should have a hit object component")
            }
        }

//        engagedHOs.forEach { engagedHO in
//            engagedHO.processInput(deltaTime: deltaTime)
//        }

        conductor.songPosition += deltaTime
    }

    func processInput(gameHO: any GameHO, inputData: InputData) {
        gameHO.checkOnInput(input: inputData, scoreManager: self.scoreManager)
    }

    func processInputEnd(gameHO: any GameHO, inputData: InputData) {
        gameHO.checkOnInputEnd(input: inputData, scoreManager: self.scoreManager)
    }
}
