//
//  HitObjectManager.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

final class HitObjectManager {
    private static var counter: Int64 = 0
    let remover: (Entity) -> Void
    var queuedHitObjects: MyQueue<any HitObject>
    let preSpawnInterval: Double
    let slideSpeed: Double

    init(
        hitObjects: [any HitObject],
        preSpawnInterval: Double,
        remover: @escaping (Entity) -> Void,
        slideSpeed: Double
    ) {
        self.remover = remover
        self.preSpawnInterval = preSpawnInterval
        self.slideSpeed = slideSpeed
        self.queuedHitObjects = MyQueue()
        hitObjects.forEach { hitObject in queuedHitObjects.enqueue(hitObject) }
    }

    // Takes in a BeatMap
    func checkBeatMap(_ currBeat: Double) -> [any GameHO] {
        var gameHOSpawned: [any GameHO] = []
        while let firstInQueue = queuedHitObjects.peek() {
            if firstInQueue.startTime - preSpawnInterval < currBeat {
                return gameHOSpawned
            }

            gameHOSpawned.append(spawnGameHitObject(firstInQueue))
            _ = queuedHitObjects.dequeue()
        }

        return gameHOSpawned
    }

    private func spawnGameHitObject(_ hitObject: any HitObject) -> any GameHO {
        // TODO: HitObject differentiation
        let entity = Entity(id: HitObjectManager.counter, remover: remover)
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
        } else {
            fatalError("Hit object type not found")
        }

        HitObjectManager.counter += 1
        return newGameHO
    }
}
