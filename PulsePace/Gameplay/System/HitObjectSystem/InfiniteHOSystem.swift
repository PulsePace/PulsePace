//
//  InfiniteHOManager.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 11/4/23.
//

class InfiniteHOSystem: HitObjectSystem {
    var beatmap: Beatmap?
    private var lastHitObject: (any HitObject)?
    private var shouldStopSpwaning = false

    override func registerEventHandlers(eventManager: EventManagable) {
        super.registerEventHandlers(eventManager: eventManager)
        eventManager.registerHandler(deathEventHandler)
    }

    override func reset() {
        super.reset()
        shouldStopSpwaning = false
    }
    override func feedBeatmap(beatmap: Beatmap) {
        super.feedBeatmap(beatmap: beatmap)
        self.beatmap = beatmap
        self.lastHitObject = queuedHitObjects.toArray().last
    }

    override func checkBeatMap(_ currBeat: Double) -> [GameHO] {
        guard let beatmap = beatmap else {
            return []
        }
        if shouldStopSpwaning {
            return []
        }
        if isNewLoop(currBeat: currBeat) {
            super.enqueueObjects(beatmap: beatmap)
        }
        return super.checkBeatMap(currBeat)
    }

    private func isNewLoop(currBeat: Double) -> Bool {
        queuedHitObjects.isEmpty && currBeat < ((lastHitObject?.startTime ?? .infinity) - preSpawnInterval)
    }

    private lazy var deathEventHandler = { [weak self] (_: EventManagable, _: SelfDeathEvent) -> Void in
        guard let self = self else {
            return
        }
        print("Receive death event?")
        self.shouldStopSpwaning = true
    }
}
