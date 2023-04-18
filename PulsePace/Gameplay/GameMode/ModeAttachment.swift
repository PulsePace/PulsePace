//
//  GameMode.swift
//  PulsePace
//
//  Created by James Chiu on 1/4/23.
//

import Foundation

final class ModeAttachment {
    let modeName: String
    let isMulti: Bool
    var hOManager: HitObjectSystem
    var evaluator: Evaluator
    var scoreSystem: ScoreSystem
    var conductor: Conductor
    var listeningMatchEvents: [any MatchEvent.Type]
    var matchEventRelay: MatchEventRelay?
    var roomSetting: RoomSetting
    var gameViewElements: [GameViewElement]

    init(modeName: String, isMulti: Bool, hOManager: HitObjectSystem, scoreSystem: ScoreSystem, conductor: Conductor,
         evaluator: Evaluator, roomSetting: RoomSetting,
         listeningMatchEvents: [any MatchEvent.Type], matchEventRelay: MatchEventRelay?,
         gameViewElements: [GameViewElement]) {
        self.modeName = modeName
        self.isMulti = isMulti
        self.hOManager = hOManager
        self.evaluator = evaluator
        self.scoreSystem = scoreSystem
        self.conductor = conductor
        self.roomSetting = roomSetting
        self.listeningMatchEvents = listeningMatchEvents
        self.matchEventRelay = matchEventRelay
        self.gameViewElements = gameViewElements
    }

    // ModeFactory reuses the same reference to each mode's ModeAttachment
    func clean() {
        hOManager.reset()
        scoreSystem.reset()
        evaluator.reset()
        matchEventRelay?.reset()
        conductor.reset()
    }

    func requires(gameViewElement: GameViewElement) -> Bool {
        self.gameViewElements.contains(gameViewElement)
    }

    func configEngine(_ gameEngine: GameEngine) {
        gameEngine.hitObjectManager = hOManager
        gameEngine.evaluator = evaluator
        gameEngine.scoreSystem = scoreSystem
        gameEngine.conductor = conductor

        if let matchEventRelay = matchEventRelay,
           let match = gameEngine.match {
            matchEventRelay.assignProperties(publisher: gameEngine.publishMatchEvent, match: match)
            gameEngine.systems.append(matchEventRelay)

            scoreSystem.attachToMatch(match)
        } else {
            print("No active match")
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
        isMulti: false,
        hOManager: HitObjectSystem(),
        scoreSystem: ScoreSystem(ScoreManager()), conductor: Conductor(),
        evaluator: DefaultEvaluator(),
        roomSetting: RoomSettingFactory.defaultSetting,
        listeningMatchEvents: [],
        matchEventRelay: nil,
        gameViewElements: [.gameplayArea, .playbackControls, .scoreBoard]
    )
    private static var infiniteMode = ModeAttachment(
        modeName: "Infinite Mode",
        isMulti: false,
        hOManager: InfiniteHOSystem(),
        scoreSystem: InfiniteScoreSystem(ScoreManager()), conductor: InfiniteConductor(),
        evaluator: InfiniteEvaluator(),
        roomSetting: RoomSettingFactory.defaultSetting,
        listeningMatchEvents: [],
        matchEventRelay: nil,
        gameViewElements: [.gameplayArea, .scoreBoard, .livesCount]
    )

    private static var coopMode = ModeAttachment(
        modeName: "Basic Coop", isMulti: true,
        hOManager: CoopHOSysytem(),
        scoreSystem: CoopScoreSystem(ScoreManager()), conductor: Conductor(),
        evaluator: CoopEvaluator(),
        roomSetting: RoomSettingFactory.baseCoopSetting,
        listeningMatchEvents: [
            PublishMissTapEvent.self, PublishMissHoldEvent.self,
            PublishMissSlideEvent.self, PublishScoreEvent.self,
            PublishGameCompleteEvent.self
        ],
        matchEventRelay: CoopMatchEventRelay(),
        gameViewElements: [.gameplayArea, .scoreBoard]
    )

    private static var competitiveMode = ModeAttachment(
        modeName: "Rhythm Battle",
        isMulti: true,
        hOManager: CompetitiveHOManager(),
        scoreSystem: CompetitiveScoreSystem(ScoreManager()), conductor: Conductor(),
        evaluator: CompetitiveEvaluator(),
        roomSetting: RoomSettingFactory.competitiveSetting,
        listeningMatchEvents: [
            PublishBombDisruptorEvent.self, PublishNoHintsDisruptorEvent.self,
            PublishDeathEvent.self, PublishScoreEvent.self
        ],
        matchEventRelay: CompetitiveMatchEventRelay(),
        gameViewElements: [
            .gameplayArea, .disruptorOptions, .matchFeed, .leaderboard, .livesCount
        ]
    )

    static func populate() {
        if isPopulated {
            return
        }
        isPopulated = true

        assemblies[defaultMode.modeName] = defaultMode
        assemblies[coopMode.modeName] = coopMode
        assemblies[competitiveMode.modeName] = competitiveMode
        assemblies[infiniteMode.modeName] = infiniteMode

        gameModes.append(
            GameMode(image: "classic-mode", category: "Singleplayer", title: "Classic Mode",
                     caption: "Tap, Slide, Hold, Win!", page: Page.beatmapSelectPage, metaInfo: defaultMode.modeName))
        gameModes.append(
            GameMode(image: "infinite-mode", category: "Singleplayer", title: "Infinite Mode",
                     caption: "Play faster until you die!", page: Page.beatmapSelectPage,
                     metaInfo: infiniteMode.modeName))
        gameModes.append(
            GameMode(image: "catch-the-potato", category: "Multiplayer", title: "Catch The Potato",
                     caption: "Make up for your partner's misses!", page: Page.lobbyPage, metaInfo: coopMode.modeName))
        gameModes.append(
            GameMode(image: "rhythm-battle", category: "Multiplayer", title: "Rhythm Battle",
                     caption: "Battle your friends with rhythm and strategy!", page: Page.lobbyPage,
                     metaInfo: competitiveMode.modeName))
    }

    /**
     Gets mode attachment before the game starts. Should only be called once as it will reset the existing game engine.
     */
    static func getModeAttachment(_ metaInfo: String) -> ModeAttachment {
        if !isPopulated {
            populate()
        }
        guard let selectedMode = assemblies[metaInfo] else {
            print("Requested mode not found, falling back to default")
            return defaultMode
        }
        selectedMode.clean()
        return selectedMode
    }

    static func getAllModes() -> [GameMode] {
        if !isPopulated {
            populate()
        }

        return gameModes
    }
}
