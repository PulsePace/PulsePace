//
//  CompetitiveHOManager.swift
//  PulsePace
//
//  Created by Charisma Kausar on 2/4/23.
//

import Foundation

class CompetitiveHOManager: HitObjectManager {
    private var disruptorsQueue = MyQueue<TapHitObject>()
    private var isSelfGameActive = true
    private var originalPreSpawnInterval = 0.0

    override func feedBeatmap(beatmap: Beatmap) {
        super.feedBeatmap(beatmap: beatmap)
        self.originalPreSpawnInterval = preSpawnInterval
    }

    override func reset() {
        super.reset()
        disruptorsQueue.removeAll()
        isSelfGameActive = true
        originalPreSpawnInterval = preSpawnInterval
    }

    override func registerEventHandlers(eventManager: EventManagable) {
        super.registerEventHandlers(eventManager: eventManager)
        eventManager.registerHandler(onSpawnBombHandler)
        eventManager.registerHandler(onActivateNoHintsHandler)
        eventManager.registerHandler(onSelfDeathHandler)
        eventManager.registerHandler(onOnlyRemainingPlayerHandler)
    }

    lazy var onSpawnBombHandler
    = { [weak self] (_: EventManagable, event: SpawnBombDisruptorEvent) -> Void in
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        guard event.bombTargetPlayerId == userConfigManager.userId else {
            return
        }
        self?.disruptorsQueue.enqueue(TapHitObject(
            position: event.bombLocation, startTime: Date().timeIntervalSince1970))
    }

    lazy var onActivateNoHintsHandler
    = { [weak self] (_: EventManagable, event: ActivateNoHintsDisruptorEvent) -> Void in
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        guard event.noHintsTargetPlayerId == userConfigManager.userId else {
            return
        }
        self?.preSpawnInterval = event.preSpawnInterval
        DispatchQueue.main.asyncAfter(deadline: .now() + event.duration) {
            self?.preSpawnInterval = self?.originalPreSpawnInterval ?? 0.0
        }
    }

    lazy var onSelfDeathHandler = { [weak self] (_: EventManagable, _: SelfDeathEvent) -> Void in
        self?.isSelfGameActive = false
    }

    lazy var onOnlyRemainingPlayerHandler = { [weak self] (_: EventManagable, _: OnlyRemainingPlayerEvent) -> Void in
        self?.isSelfGameActive = false
    }

    override func checkBeatMap(_ currBeat: Double) -> [any GameHO] {
        guard isSelfGameActive else {
            return []
        }
        var gameHOSpawned = super.checkBeatMap(currBeat)
        while let disruptorHO = disruptorsQueue.peek() {
            disruptorHO.startTime = ceil(currBeat)
            guard let gameHO = spawnGameHitObject(disruptorHO) as? TapGameHO else {
                continue
            }
            let bomb = BombGameHO(tapGameHO: gameHO)
            gameHOSpawned.append(bomb)
            _ = disruptorsQueue.dequeue()
        }
        return gameHOSpawned
    }
}
