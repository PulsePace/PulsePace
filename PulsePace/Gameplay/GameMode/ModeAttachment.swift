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
    var scoreManager: ScoreManager

    init(modeName: String, hOManager: HitObjectManager, scoreManager: ScoreManager) {
        self.modeName = modeName
        self.hOManager = hOManager
        self.scoreManager = scoreManager
    }

    func configEngine(_ gameEngine: GameEngine) {
        gameEngine.hitObjectManager = hOManager
        gameEngine.scoreManager = scoreManager
    }
}

final class ModeFactory {
    static var modeNames: [String] = []
    static var nameToModeAttachmentTable: [String: ModeAttachment] = [:]
    static var defaultMode: ModeAttachment = {
        let singleMode = ModeAttachment(
            modeName: "Single Player",
            hOManager: HitObjectManager(),
            scoreManager: ScoreManager()
        )
        let coopMode = ModeAttachment(
            modeName: "Basic Coop",
            hOManager: CoopHOManager(),
            scoreManager: ScoreManager()
        )
        return singleMode
    }()
}
