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
    var sceneAdaptor: (any Collection<any GameHO>) -> Void { get }
}

class GameViewModel: ObservableObject, RenderSystem {
    private var displayLink: CADisplayLink?
    private var gameEngine: GameEngine?
    @Published var slideGameHOs: [SlideGameHO] = []
    @Published var holdGameHOs: [HoldGameHO] = []
    @Published var tapGameHOs: [TapGameHO] = []
    var score: String {
        String(format: "%06d", 71_143)
    }

    var accuracy: String {
        String(Double(round(100 * 82.3883) / 100)) + "%"
    }

    var combo: String {
        String(14) + "x"
    }

    var health: Double {
        50
    }

    lazy var sceneAdaptor: (any Collection<any GameHO>) -> Void = { [weak self] gameHOs in
        self?.clear()
        gameHOs.forEach { gameHO in
            if let slideGameHO = gameHO as? SlideGameHO {
                self?.slideGameHOs.append(slideGameHO)
            } else if let holdGameHO = gameHO as? HoldGameHO {
                self?.holdGameHOs.append(holdGameHO)
            } else if let tapGameHO = gameHO as? TapGameHO {
                self?.tapGameHOs.append(tapGameHO)
            } else {
                print("Unidentified game HO type")
            }
        }
    }

    private func clear() {
        slideGameHOs.removeAll()
        holdGameHOs.removeAll()
        tapGameHOs.removeAll()
    }

    var gameBackground: String {
        "game-background"
    }

    @objc func step(displaylink: CADisplayLink) {
        gameEngine?.step(60)
    }

    func startGameplay() {
        gameEngine = GameEngine()
        createDisplayLink()
    }

    func stopGameplay() {
        displayLink?.invalidate()
    }

    private func createDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .default)
    }

}
