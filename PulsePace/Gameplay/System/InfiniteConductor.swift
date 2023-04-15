//
//  InfiniteConductor.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 11/4/23.
//

class InfiniteConductor: Conductor {
    var totalTimeElapsed: Double = 0
    private let playbackRateUpdateInterval = 0.25
    private let playbackRateUpdateComboCount = 5

    override func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(loseLifeEventHandler)
        eventManager.registerHandler(updateComboEventHandler)
    }
    override func step(deltaTime: Double, songPosition: Double) {
        super.step(deltaTime: deltaTime, songPosition: songPosition)
        self.songPosition = self.songPosition.truncatingRemainder(dividingBy: totalBeats)
        totalTimeElapsed += deltaTime
    }

    override func reset() {
        totalTimeElapsed = 0
        songPosition = 0
        playbackScale = 1
    }

    private lazy var loseLifeEventHandler = { [weak self] (_: EventManagable, _: LoseLifeEvent) -> Void in
        guard let self = self else {
            return
        }
        self.updatePlaybackRate(by: -self.playbackRateUpdateInterval)
    }

    private lazy var updateComboEventHandler = { [weak self] (_: EventManagable, event: UpdateComboEvent) -> Void in
        guard let self = self else {
            return
        }
        if self.shouldIncreaseSpeed(comboCount: event.comboCount) {
            self.updatePlaybackRate(by: self.playbackRateUpdateInterval)
        }
    }

    private func updatePlaybackRate(by rate: Double) {
        let clamped = Math.clamp(num: playbackScale + rate, minimum: 1, maximum: 2)
        playbackScale = clamped
    }

    private func shouldIncreaseSpeed(comboCount: Int) -> Bool {
        comboCount > 0 && comboCount.isMultiple(of: playbackRateUpdateComboCount)
    }
}
