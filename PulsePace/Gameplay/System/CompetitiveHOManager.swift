//
//  CompetitiveHOManager.swift
//  PulsePace
//
//  Created by Charisma Kausar on 2/4/23.
//

import Foundation

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

    lazy var onActivateNoHintsHandler
    = { [weak self] (eventManager: EventManagable, event: ActivateNoHintsDisruptorEvent) -> Void in
        guard event.noHintsTargetPlayerId == UserConfig().userId else {
            return
        }
        let originalPreSpawnInterval = self?.preSpawnInterval
        self?.preSpawnInterval = event.preSpawnInterval
        DispatchQueue.main.asyncAfter(deadline: .now() + event.duration) {
            self?.preSpawnInterval = originalPreSpawnInterval ?? 0.0
            eventManager.add(event: DeactivateNoHintsDisruptorEvent(timestamp: Date().timeIntervalSince1970,
                                                                    noHintsTargetPlayerId: event.noHintsTargetPlayerId))
        }
    }
}
