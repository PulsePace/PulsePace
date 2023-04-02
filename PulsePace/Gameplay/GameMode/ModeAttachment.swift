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
    var roomSetting: RoomSetting

    init(modeName: String, hOManager: HitObjectManager, scoreSystem: ScoreSystem, roomSetting: RoomSetting) {
        self.modeName = modeName
        self.hOManager = hOManager
        self.scoreSystem = scoreSystem
        self.roomSetting = roomSetting
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
        scoreSystem: ScoreSystem(scoreManager: ScoreManager()),
        roomSetting: RoomSettingFactory.defaultSetting
    )

    static func populateFactory() {
        isPopulated = true

        let coopMode = ModeAttachment(
            modeName: "Basic Coop",
            hOManager: CoopHOManager(),
            scoreSystem: ScoreSystem(scoreManager: ScoreManager()),
            roomSetting: RoomSettingFactory.baseCoopSetting
        )

        nameToModeAttachmentTable[defaultMode.modeName] = defaultMode
        nameToModeAttachmentTable[coopMode.modeName] = coopMode
        gameModes.append(
            GameMode(image: "", category: "Singleplayer", title: "Classic Mode",
                     caption: "Tap, Slide, Hold, Win!", page: Page.playPage, metaInfo: defaultMode.modeName))
        gameModes.append(
            GameMode(image: "", category: "Multiplayer", title: "Catch The Potato",
                     caption: "Make up for your partner's misses!", page: Page.lobbyPage, metaInfo: coopMode.modeName))
        // @Charisma
        gameModes.append(
            GameMode(image: "", category: "Multiplayer", title: "Beat-Off",
                     caption: "Battle your friends with rhythm and strategy!", page: Page.lobbyPage, metaInfo: ""))
    }

    static func getModeAttachment(_ metaInfo: String) -> ModeAttachment {
        if !isPopulated {
            populateFactory()
        }
        guard let selectedMode = nameToModeAttachmentTable[metaInfo] else {
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
