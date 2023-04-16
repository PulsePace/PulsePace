//
//  CoopHOManager.swift
//  PulsePace
//
//  Created by James Chiu on 1/4/23.
//

import Foundation

class CoopHOSysytem: HitObjectSystem {
    private var rearrangedMissedHO = PriorityQueue<any HitObject> { a, b in a.startTime < b.startTime }
    let minMissSpawnDelay = 5.0
    let maxMissSpawnDelay = 9.0

    override func reset() {
        super.reset()
        rearrangedMissedHO.removeAll()
    }

    lazy var onPartnerMissHandler = { [weak self] (_: EventManagable, event: SpawnHOEvent) -> Void in
        guard let self = self else {
            fatalError("No active coop hit object manager")
        }
        let lifeTime = event.hitObject.endTime - event.hitObject.startTime
        event.hitObject.startTime = Double.random(
            in: self.minMissSpawnDelay...self.maxMissSpawnDelay) + event.hitObject.startTime
        event.hitObject.endTime = event.hitObject.startTime + lifeTime
        self.rearrangedMissedHO.enqueue(event.hitObject)
        self.songEndBeat = max(self.songEndBeat, event.hitObject.endTime)
    }

    override func registerEventHandlers(eventManager: EventManagable) {
        super.registerEventHandlers(eventManager: eventManager)
        eventManager.registerHandler(onPartnerMissHandler)
    }

    override func checkBeatMap(_ currBeat: Double) -> [any GameHO] {
        var gameHOSpawned = super.checkBeatMap(currBeat)
        while let firstInMissed = rearrangedMissedHO.peek() {
            let lifeTime = firstInMissed.startTime - firstInMissed.endTime
            firstInMissed.startTime = max(firstInMissed.startTime, floor(currBeat))
            firstInMissed.endTime = firstInMissed.startTime + lifeTime
            if firstInMissed.startTime - preSpawnInterval + offset >= currBeat {
                return gameHOSpawned
            }
            gameHOSpawned.append(spawnMissedHitObject(firstInMissed))
            _ = rearrangedMissedHO.dequeue()
            songEndBeat = max(songEndBeat, firstInMissed.endTime)
        }

        return gameHOSpawned
    }

    func spawnMissedHitObject(_ hitObject: any HitObject) -> any GameHO {
        let gameHO = super.spawnGameHitObject(hitObject)
        gameHO.fromPartner = true
        return gameHO
    }
}
