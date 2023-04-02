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

class CompetitiveHOManager: HitObjectManager {
    private var disruptorsQueue = MyQueue<any HitObject>()

    override func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(onSpawnBombHandler)
        eventManager.registerHandler(onActivateNoHintsHandler)
    }

    lazy var onSpawnBombHandler = { [weak self] (_: EventManagable, event: SpawnBombDisruptorEvent) -> Void in
        guard event.bombTargetPlayerId == UserConfig().userId else {
            return
        }
        self?.disruptorsQueue.enqueue(TapHitObject(
            position: event.bombLocation, startTime: Date().addingTimeInterval(5).timeIntervalSince1970))
    }

    lazy var
    onActivateNoHintsHandler = { [weak self] (_: EventManagable, event: ActivateNoHintsDisruptorEvent) -> Void in
        guard event.noHintsTargetPlayerId == UserConfig().userId else {
            return
        }
        let originalPreSpawnInterval = self?.preSpawnInterval
        self?.preSpawnInterval = event.preSpawnInterval
        DispatchQueue.main.asyncAfter(deadline: .now() + event.duration) {
            self?.preSpawnInterval = originalPreSpawnInterval ?? 0.0
        }
    }
}
