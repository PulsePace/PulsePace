//
//  GameMode.swift
//  PulsePace
//
//  Created by James Chiu on 1/4/23.
//

import Foundation

struct GameSetting {
    let minPlayerCount: Int
    let maxPlayerCount: Int
}

final class ModeAttachment {
    let modeName: String
    var hOManager: HitObjectManager
    var scoreManager: ScoreManager
    var setting: GameSetting

    init(modeName: String, hOManager: HitObjectManager, scoreManager: ScoreManager, setting: GameSetting) {
        self.modeName = modeName
        self.hOManager = hOManager
        self.scoreManager = scoreManager
        self.setting = setting
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
        let singleMode = ModeAttachment(modeName: "Single Player", hOManager: HitObjectManager(), scoreManager: ScoreManager(), setting: GameSetting(minPlayerCount: 1, maxPlayerCount: 1))
        let coopMode = ModeAttachment(modeName: "Basic Coop", hOManager: CoopHOManager(), scoreManager: ScoreManager(), setting: GameSetting(minPlayerCount: 2, maxPlayerCount: 2))
        return singleMode
    }()
}
