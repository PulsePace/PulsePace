//
//  CoopHOManager.swift
//  PulsePace
//
//  Created by James Chiu on 1/4/23.
//

import Foundation

class CoopHOManager: HitObjectManager {
    private var partnerMissedHO = MyQueue<any HitObject>()
    let minMissSpawnDelay = 1
    let maxMissSpawnDelay = 5

    lazy var onPartnerMissHandler = { [weak self] (_: EventManagable, event: SpawnHOEvent) -> Void in
        self?.partnerMissedHO.enqueue(event.hitObject)
    }

    override func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(onPartnerMissHandler)
    }

    override func checkBeatMap(_ currBeat: Double) -> [any GameHO] {
        var gameHOSpawned = super.checkBeatMap(currBeat)
        while let firstInMissed = partnerMissedHO.peek() {
            firstInMissed.startTime = ceil(currBeat)
            gameHOSpawned.append(spawnGameHitObject(firstInMissed))
            _ = partnerMissedHO.dequeue()
        }

        return gameHOSpawned
    }
}
