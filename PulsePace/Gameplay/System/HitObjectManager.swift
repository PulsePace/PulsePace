//
//  HitObjectManager.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

class HitObjectManager: System {
    private var counter = 0
    private var remover: ((Entity) -> Void)?
    private var queuedHitObjects: MyQueue<any HitObject>
    private var offset = 0.0
    private var slideSpeed = 0.0
    var preSpawnInterval = 0.0

    func registerEventHandlers(eventManager: EventManagable) {
        lazy var noHandler = { (_: EventManagable, _: NoEvent) -> Void in
            fatalError("No event should not be emitted")
        }
        eventManager.registerHandler(noHandler)
    }

    init() {
        queuedHitObjects = MyQueue()
    }

    func feedBeatmap(beatmap: Beatmap, remover: @escaping (Entity) -> Void) {
        self.remover = remover
        self.preSpawnInterval = beatmap.preSpawnInterval
        self.offset = beatmap.offset
        self.slideSpeed = beatmap.sliderSpeed
        beatmap.hitObjects.forEach { hitObject in queuedHitObjects.enqueue(hitObject) }
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

    func spawnGameHitObject(_ hitObject: any HitObject) -> any GameHO {
        guard let remover = remover else {
            fatalError("Hit object manager must have a valid remover")
        }
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
