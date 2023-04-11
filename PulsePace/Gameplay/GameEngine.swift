//
//  GameEngine.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

class GameEngine {
    var scoreSystem: ScoreSystem?
    var scoreManager: ScoreManager {
        guard let scoreSystem = scoreSystem else {
            fatalError("Score system has no score manager")
        }
        return scoreSystem.scoreManager
    }

    var hitObjectManager: HitObjectManager?
    var matchFeedSystem: MatchFeedSystem?
    private var inputManager: InputManager?
    var conductor: Conductor?

    var match: Match?
    var eventManager = EventManager()
    var systems: [System] = []

    init(_ modeAttachment: ModeAttachment, match: Match? = nil) {

        if let match = match {
            self.match = match
            eventManager.setMatchEventHandler(matchEventHandler: self)
            matchFeedSystem = MatchFeedSystem(playerNames: match.players)
            if let matchFeedSystem = matchFeedSystem {
                systems.append(matchFeedSystem)
            }
            print("Match id \(match.matchId)")
        } else {
            print("No match attached to engine")
        }

        systems.append(InputSystem())

        modeAttachment.configEngine(self)
        guard let hitObjectManager = hitObjectManager, let scoreSystem = scoreSystem else {
            fatalError("Mode attachment should have initialized hit object manager and score system")
        }

        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        // TODO: Move to mode attachment
        if let disruptorSystem = scoreSystem as? DisruptorSystem,
           let match = match {
            disruptorSystem.selectedTarget = match.players.first(where: { $0.key != userConfigManager.userId })?.key
            ?? userConfigManager.userId
            match.players.forEach({ disruptorSystem.allScores[$0.key] = 0 })
        }
        systems.append(hitObjectManager)
        systems.append(scoreSystem)
        systems.forEach({ $0.registerEventHandlers(eventManager: self.eventManager) })
    }

    func load(_ beatmap: Beatmap) {
        hitObjectManager?.feedBeatmap(beatmap: beatmap, eventManager: self.eventManager)
        self.conductor = Conductor(bpm: beatmap.bpm)
    }

    func step(_ deltaTime: Double) {
        guard let conductor = conductor else {
            print("Cannot advance engine state without conductor")
            return
        }
        conductor.step(deltaTime)
        systems.forEach({ $0.step(deltaTime: deltaTime, songPosition: conductor.songPosition) })
        eventManager.handleAllEvents()
    }

    func setTarget(targetId: String) {
        guard let disruptorSystem = scoreSystem as? DisruptorSystem else {
           return
        }
        disruptorSystem.setTarget(targetId: targetId)
    }

    func setDisruptor(disruptor: Disruptor) {
        guard let disruptorSystem = scoreSystem as? DisruptorSystem else {
           return
        }
        disruptorSystem.setDisruptor(disruptor: disruptor)
    }
}

extension GameEngine: MatchEventHandler {
    func publishMatchEvent(message: MatchEventMessage) {
        match?.dataManager.publishEvent(matchEvent: message)
    }

    func subscribeMatchEvents() {
        match?.dataManager.subscribeEvents(eventManager: eventManager)
    }
}

protocol MatchEventHandler: AnyObject {
    func publishMatchEvent(message: MatchEventMessage)
    func subscribeMatchEvents()
}
