//
//  GameEngine.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

// TODO: Add conductor
class GameEngine {
    var allObjects: Set<Entity>
    var gameHOTable: [Entity: any GameHO]
    var hitObjectManager: HitObjectManager?

    lazy var objRemover: (Entity) -> Void = { [weak self] removedObject in
        self?.allObjects.remove(removedObject)
        self?.gameHOTable.removeValue(forKey: removedObject)
    }

    lazy var gameHOAdder: (any GameHO) -> Void = { [weak self] gameHO in
        self?.allObjects.insert(gameHO.wrappingObject)
        self?.gameHOTable[gameHO.wrappingObject] = gameHO
    }

    init() {
        self.allObjects = Set()
        self.gameHOTable = [:]
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
        // TODO: swap currBeat with conductor reading
        if let spawnGameHOs = hitObjectManager?.checkBeatMap(0) {
            spawnGameHOs.forEach { gameHOAdder($0) }
        }

        // Should contain all hitobjects that have been "touched" this frame
        var engagedHOs: [any GameHO] = []
        /// Update state of gameHO -> process all inputs on HO
        /// -> delegate responses to respective system -> delegate UI display to renderer
        allObjects.forEach { object in
            if let gameHO = gameHOTable[object] {
                // TODO: Use actual conductor for currBeat
                gameHO.updateState(currBeat: 0)
                if gameHO.shouldExecute {
                    engagedHOs.append(gameHO)
                }
            } else {
                print("By game design params, all objects should have a hit object component")
            }
        }

        engagedHOs.forEach { engagedHO in
            engagedHO.processInput(deltaTime: deltaTime)
        }
    }
}
