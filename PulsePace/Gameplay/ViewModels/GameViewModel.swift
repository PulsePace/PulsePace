//
//  GameViewModel.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

import Foundation
import QuartzCore
import AVKit

protocol RenderSystem {
    var sceneAdaptor: ([Entity: any GameHO]) -> Void { get }
}

class GameViewModel: ObservableObject, RenderSystem {
    private var displayLink: CADisplayLink?
    var gameEngine: GameEngine?
    private var audioPlayer: AVAudioPlayer?
    @Published var slideGameHOs: [SlideGameHOVM] = []
    @Published var holdGameHOs: [HoldGameHOVM] = []
    @Published var tapGameHOs: [TapGameHOVM] = []
    @Published var songPosition: Double = 0
    @Published var matchFeedMessages: [MatchFeedMessage] = []
    @Published var gameEnded = false

    var frame = CGSize.zero

    var score: String {
        guard let scoreManager = gameEngine?.scoreSystem?.scoreManager else {
            return String(0)
        }
        return String(format: "%06d", scoreManager.score)
    }

    var gameEndScore: String {
        guard let scoreSystem = gameEngine?.scoreSystem else {
            return String(0)
        }
        return String(scoreSystem.getGameEndScore())
    }

    var accuracy: String {
        String(Double(round(100 * 82.3883) / 100)) + "%"
    }

    var combo: String {
        guard let scoreManager = gameEngine?.scoreSystem?.scoreManager else {
            return String(0)
        }
        return String(scoreManager.comboCount) + "x"
    }

    var livesCount: Int {
        guard let scoreManager = gameEngine?.scoreSystem?.scoreManager else {
            return 1
        }
        return scoreManager.livesRemaining
    }

    var hitStatus: String {
        guard let scoreManager = gameEngine?.scoreSystem?.scoreManager,
              let latestHitStatus = scoreManager.latestHitStatus else {
            return String()
        }
        var count = ""
        switch latestHitStatus {
        case .perfect:
            count = "x" + String(scoreManager.perfectCount)
        case .good:
            count = "x" + String(scoreManager.goodCount)
        case .miss:
            count = "x" + String(scoreManager.missCount)
        }
        return latestHitStatus.description + count
    }

    var hoCount: Int {
        guard let scoreManager = gameEngine?.scoreSystem?.scoreManager else {
            return 0
        }
        return scoreManager.goodCount + scoreManager.perfectCount + scoreManager.missCount
    }

    var disruptors = Disruptor.allCases.map({ $0.rawValue })

    var selectedGameMode: ModeAttachment = ModeFactory.defaultMode
    var match: Match?

    typealias DictAsArray = [(key: String, value: String)]
    var otherPlayers: DictAsArray = []
    var leaderboard: DictAsArray = []

    private lazy var gameEnder: () -> Void = { [weak self] in
        print("Game ended")
        self?.stopGameplay()
        self?.gameEnded = true
    }

    lazy var sceneAdaptor: ([Entity: any GameHO]) -> Void = { [weak self] gameHOTable in
        self?.clear()
        guard let gameEngine = self?.gameEngine else {
            return
        }
        gameHOTable.forEach { gameHOEntity in
            if let slideGameHO = gameHOEntity.value as? SlideGameHO {
                self?.slideGameHOs.append(SlideGameHOVM(gameHO: slideGameHO, id: gameHOEntity.key.id,
                                                        eventManager: gameEngine.eventManager))
            } else if let holdGameHO = gameHOEntity.value as? HoldGameHO {
                self?.holdGameHOs.append(HoldGameHOVM(gameHO: holdGameHO, id: gameHOEntity.key.id,
                                                      eventManager: gameEngine.eventManager))
            } else if let tapGameHO = gameHOEntity.value as? TapGameHO {
                self?.tapGameHOs.append(TapGameHOVM(gameHO: tapGameHO, id: gameHOEntity.key.id,
                                                    eventManager: gameEngine.eventManager))
            } else {
                print("Unidentified game HO type")
            }
        }
    }

    private func clear() {
        slideGameHOs = []
        holdGameHOs = []
        tapGameHOs = []
    }

    var gameBackground: String {
        "game-background"
    }

    @objc func step() {
        guard let displayLink = displayLink else {
            print("No active display link")
            return
        }

        guard let gameEngine = gameEngine else {
            print("No game engine running")
            return
        }

        guard let hitObjectManager = gameEngine.hitObjectManager else {
            print("No HitObjectManager initialised")
            return
        }

        let deltaTime = displayLink.targetTimestamp - displayLink.timestamp

        gameEngine.step(deltaTime)
        sceneAdaptor(hitObjectManager.gameHOTable)

        guard audioPlayer != nil else {
            print("No song player")
            return
        }

        updateMatchFeed()
        updateLeaderboard()
        songPosition = gameEngine.conductor?.songPosition ?? 0
    }

    func assignMatch(_ match: Match) {
        self.match = match
        self.otherPlayers = []
        match.players.forEach({
            if $0.key != UserConfig().userId {
                self.otherPlayers.append((key: $0.key, value: $0.value))
            }
        })
    }

    func initEngine(with beatmap: Beatmap) {
        selectedGameMode.clean()
        gameEngine = GameEngine(modeAttachment: selectedGameMode, gameEnder: gameEnder, match: match)
        gameEngine?.load(beatmap)
    }

    func initialiseFrame(size: CGSize) {
        frame = size
    }

    func startGameplay() {
        createDisplayLink()
    }

    func toggleGameplay() {
        guard let isPaused = displayLink?.isPaused else {
            print("No active display link")
            return
        }

        displayLink?.isPaused = !isPaused
    }

    func stopGameplay() {
        audioPlayer?.stop()
    }

    func exitGameplay() {
        displayLink?.invalidate()
        gameEnded = false
        gameEngine = nil
        match = nil
        clear()
    }

    func initialisePlayer(audioPlayer: AVAudioPlayer) {
        self.audioPlayer = audioPlayer
    }

    func setTarget(_ targetId: String) {
        gameEngine?.setTarget(targetId: targetId)
    }

    func setDisruptor(_ disruptor: Disruptor) {
        gameEngine?.setDisruptor(disruptor: disruptor)
    }

    private func createDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 75, maximum: 150, __preferred: 90)
        displayLink?.add(to: .current, forMode: .default)
    }

    private func updateMatchFeed() {
        matchFeedMessages = gameEngine?.matchFeedSystem?.matchFeedMessages.toArray() ?? []
        matchFeedMessages.sort(by: { x, y in x.timestamp < y.timestamp })
    }

    private func updateLeaderboard() {
        leaderboard = []
        (gameEngine?.scoreSystem as? DisruptorSystem)?.allScores.forEach({
            leaderboard.append((key: match?.players[$0.key] ?? "Anonymous",
                                value: String(format: "%06d", $0.value)))
            leaderboard.sort(by: { x, y in Int(x.value) ?? 0 > Int(y.value) ?? 0 })
        })
    }
}
