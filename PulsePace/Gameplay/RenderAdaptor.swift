//
//  RenderAdaptor.swift
//  PulsePace
//
//  Created by James Chiu on 17/3/23.
//

import Foundation

class RenderAdaptor: ObservableObject, RenderSystem {
    @Published var slideGameHOs: [SlideGameHO] = []
    @Published var holdGameHOs: [HoldGameHO] = []
    @Published var tapGameHOs: [TapGameHO] = []
    var gameEngine: GameEngine

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

    init() {
        self.gameEngine = GameEngine()
        gameEngine.onStepComplete.append(sceneAdaptor)
    }
}

protocol RenderSystem {
    var sceneAdaptor: (any Collection<any GameHO>) -> Void { get }
}
