//
//  CoopHOManager.swift
//  PulsePace
//
//  Created by James Chiu on 1/4/23.
//

import Foundation

// TODO: Apply delay to missedHO
class CoopHOManager: HitObjectManager {
    private var partnerMissedHO = MyQueue<any HitObject>()
//    private var rearrangedMissedHO = PriorityQueue<any HitObject> { a, b in a.startTime < b.startTime}
    let minMissSpawnDelay = 3
    let maxMissSpawnDelay = 7

    override func reset() {
        super.reset()
        partnerMissedHO.removeAll()
    }

    lazy var onPartnerMissHandler = { [weak self] (_: EventManagable, event: SpawnHOEvent) -> Void in
        self?.partnerMissedHO.enqueue(event.hitObject)
//        self?.rearrangedMissedHO.enqueue(event.hitObject)
    }

    override func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(onPartnerMissHandler)
    }

    override func checkBeatMap(_ currBeat: Double) -> [any GameHO] {
        var gameHOSpawned = super.checkBeatMap(currBeat)
        while let firstInMissed = partnerMissedHO.peek() {
            let originalStartTime = firstInMissed.startTime
            firstInMissed.startTime = ceil(currBeat)
            firstInMissed.endTime = firstInMissed.startTime + firstInMissed.endTime - originalStartTime
            gameHOSpawned.append(spawnMissedHitObject(firstInMissed))
            _ = partnerMissedHO.dequeue()
        }

        return gameHOSpawned
    }

    func spawnMissedHitObject(_ hitObject: any HitObject) -> any GameHO {
        let gameHO = super.spawnGameHitObject(hitObject)
        gameHO.fromPartner = true
        return gameHO
    }
}
