//
//  GameMode.swift
//  PulsePace
//
//  Created by James Chiu on 1/4/23.
//

import Foundation

final class ModeAttachment {
    let modeName: String
    var hOManager: HitObjectManager
    var scoreSystem: ScoreSystem

    init(modeName: String, hOManager: HitObjectManager, scoreSystem: ScoreSystem) {
        self.modeName = modeName
        self.hOManager = hOManager
        self.scoreSystem = scoreSystem
    }

    func configEngine(_ gameEngine: GameEngine) {
        gameEngine.hitObjectManager = hOManager
        gameEngine.scoreSystem = scoreSystem
    }
}

final class ModeFactory {
    static var modeNames: [String] = []
    static var nameToModeAttachmentTable: [String: ModeAttachment] = [:]
    static var defaultMode: ModeAttachment = {
        let singleMode = ModeAttachment(
            modeName: "Single Player",
            hOManager: HitObjectManager(),
            scoreSystem: ScoreSystem(scoreManager: ScoreManager())
        )
        let coopMode = ModeAttachment(
            modeName: "Basic Coop",
            hOManager: CoopHOManager(),
            scoreSystem: ScoreSystem(scoreManager: ScoreManager())
        )
        return singleMode
    }()
}
