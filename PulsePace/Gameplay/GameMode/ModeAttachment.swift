//
//  GameMode.swift
//  PulsePace
//
//  Created by James Chiu on 1/4/23.
//

import Foundation

enum PlayCat: String {
    case singlePlayer = "Singleplayer", mulitplayer = "Multiplayer"

    var description: String {
        self.rawValue
    }
}

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
    private static var isPopulated = false
    private static var gameModes: [GameMode] = []
    private static var nameToModeAttachmentTable: [String: ModeAttachment] = [:]
    static var defaultMode = ModeAttachment(
        modeName: "Classic",
        hOManager: HitObjectManager(),
        scoreSystem: ScoreSystem(scoreManager: ScoreManager())
    )

    static func populateFactory() {
        isPopulated = true

        let coopMode = ModeAttachment(
            modeName: "Basic Coop",
            hOManager: CoopHOManager(),
            scoreSystem: ScoreSystem(scoreManager: ScoreManager())
        )

        nameToModeAttachmentTable[defaultMode.modeName] = defaultMode
        nameToModeAttachmentTable[coopMode.modeName] = coopMode
        gameModes.append(
            GameMode(image: "", category: "Singleplayer", title: "Classic Mode",
                     caption: "Tap, Slide, Hold, Win!", page: Page.playPage, modeName: defaultMode.modeName))
        gameModes.append(
            GameMode(image: "", category: "Multiplayer", title: "Catch The Potato",
                     caption: "Make up for your partner's misses!", page: Page.lobbyPage, modeName: coopMode.modeName))
        // @Charisma
        gameModes.append(
            GameMode(image: "", category: "Multiplayer", title: "Beat-Off",
                     caption: "Battle your friends with rhythm and strategy!", page: Page.lobbyPage, modeName: ""))
    }

    static func getModeAttachment(modeName: String) -> ModeAttachment {
        if !isPopulated {
            populateFactory()
        }
        guard let selectedMode = nameToModeAttachmentTable[modeName] else {
            print("Request mode not found, falling back to default")
            return defaultMode
        }
        return selectedMode
    }

    static func getAllModes() -> [GameMode] {
        if !isPopulated {
            populateFactory()
        }

        return gameModes
    }
}
