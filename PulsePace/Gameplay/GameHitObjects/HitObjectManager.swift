//
//  HitObjectManager.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

final class HitObjectManager {
    private var counter = 0
    let remover: (Entity) -> Void
    private var queuedHitObjects: MyQueue<any HitObject>
    let offset: Double
    let preSpawnInterval: Double
    let slideSpeed: Double

    init(
        hitObjects: [any HitObject],
        preSpawnInterval: Double,
        remover: @escaping (Entity) -> Void,
        offset: Double,
        slideSpeed: Double
    ) {
        self.remover = remover
        self.preSpawnInterval = preSpawnInterval
        self.offset = offset
        self.slideSpeed = slideSpeed
        self.queuedHitObjects = MyQueue()
        hitObjects.forEach { hitObject in queuedHitObjects.enqueue(hitObject) }
    }

    // Takes in a BeatMap
    func checkBeatMap(_ currBeat: Double) -> [any GameHO] {
        var gameHOSpawned: [any GameHO] = []
        while let firstInQueue = queuedHitObjects.peek() {
            if firstInQueue.startTime - preSpawnInterval + offset >= currBeat {
                return gameHOSpawned
            }

            gameHOSpawned.append(spawnGameHitObject(firstInQueue))
            _ = queuedHitObjects.dequeue()
        }

        return gameHOSpawned
    }

    private func spawnGameHitObject(_ hitObject: any HitObject) -> any GameHO {
        // TODO: HitObject differentiation
        let entity = Entity(id: counter, remover: remover)
        let newGameHO: any GameHO
        if let tapHO = hitObject as? TapHitObject {
            newGameHO = TapGameHO(tapHO: tapHO, wrappingObject: entity, preSpawnInterval: preSpawnInterval)
        } else if let slideHO = hitObject as? SlideHitObject {
            newGameHO = SlideGameHO(
                slideHO: slideHO,
                wrappingObject: entity,
                preSpawnInterval: preSpawnInterval,
                slideSpeed: slideSpeed
            )
        } else if let holdHO = hitObject as? HoldHitObject {
            newGameHO = HoldGameHO(
                holdHO: holdHO,
                wrappingObject: entity,
                preSpawnInterval: preSpawnInterval
            )
        } else {
            fatalError("Hit object type not found")
        }

        counter += 1
        return newGameHO
    }
}
