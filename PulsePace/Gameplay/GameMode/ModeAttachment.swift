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
    var listeningMatchEvents: [any MatchEvent.Type]
    var matchEventRelay: MatchEventRelay?
    var roomSetting: RoomSetting

    init(modeName: String, hOManager: HitObjectManager, scoreSystem: ScoreSystem, roomSetting: RoomSetting,
         listeningMatchEvents: [any MatchEvent.Type], matchEventRelay: MatchEventRelay?) {
        self.modeName = modeName
        self.hOManager = hOManager
        self.scoreSystem = scoreSystem
        self.roomSetting = roomSetting
        self.listeningMatchEvents = listeningMatchEvents
        self.matchEventRelay = matchEventRelay
    }

    func configEngine(_ gameEngine: GameEngine) {
        gameEngine.hitObjectManager = hOManager
        gameEngine.scoreSystem = scoreSystem
        if let matchEventRelay = matchEventRelay {
            // FIXME: remove stubs
            matchEventRelay.assignProperties(userId: "", publisher: gameEngine.publishMatchEvent, match: Match(matchId: "", modeName: ""))
            gameEngine.systems.append(matchEventRelay)
        }
    }
}

protocol Factory {
    associatedtype ProductType
    static var isPopulated: Bool { get }
    static var assemblies: [String: ProductType] { get }
    static func populate()
}

final class ModeFactory: Factory {
    static var isPopulated = false
    private static var gameModes: [GameMode] = []
    static var assemblies: [String: ModeAttachment] = [:]
    static var defaultMode = ModeAttachment(
        modeName: "Classic",
        hOManager: HitObjectManager(),
        scoreSystem: ScoreSystem(scoreManager: ScoreManager()),
        roomSetting: RoomSettingFactory.defaultSetting,
        listeningMatchEvents: [],
        matchEventRelay: nil
    )

    static func populate() {
        if isPopulated {
            return
        }
        isPopulated = true

        let coopMode = ModeAttachment(
            modeName: "Basic Coop",
            hOManager: CoopHOManager(),
            scoreSystem: ScoreSystem(scoreManager: ScoreManager()),
            roomSetting: RoomSettingFactory.baseCoopSetting,
            listeningMatchEvents: [PublishMissTapEvent.self, PublishMissHoldEvent.self, PublishMissSlideEvent.self],
            matchEventRelay: CoopMatchEventRelay()
        )

        assemblies[defaultMode.modeName] = defaultMode
        assemblies[coopMode.modeName] = coopMode
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
            populate()
        }
        guard let selectedMode = assemblies[metaInfo] else {
            print("Request mode not found, falling back to default")
            return defaultMode
        }
        return selectedMode
    }

    static func getAllModes() -> [GameMode] {
        if !isPopulated {
            populate()
        }

        return gameModes
    }
}
