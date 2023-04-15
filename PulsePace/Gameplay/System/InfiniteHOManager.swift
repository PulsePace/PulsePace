//
//  InfiniteHOManager.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 11/4/23.
//

class InfiniteHOManager: HitObjectManager {
    var beatmap: Beatmap?
    private var lastHitObject: (any HitObject)?

    override func feedBeatmap(beatmap: Beatmap) {
        super.feedBeatmap(beatmap: beatmap)
        self.beatmap = beatmap
        self.lastHitObject = queuedHitObjects.toArray().last
    }
    override func checkBeatMap(_ currBeat: Double) -> [GameHO] {
        guard let beatmap = beatmap else {
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

}
