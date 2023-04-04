//
//  GameHOVM.swift
//  PulsePace
//
//  Created by James Chiu on 18/3/23.
//

import Foundation

class GameHOVM<T: GameHO>: Identifiable {
    let gameHO: T
    let id: Int
    let eventManager: EventManager

    var fromPartner: Bool {
        gameHO.fromPartner
    }

    init(gameHO: T, id: Int, eventManager: EventManager) {
        self.gameHO = gameHO
        self.id = id
        self.eventManager = eventManager
    }
}

class TapGameHOVM: GameHOVM<TapGameHO> {
    var ringScale: Double {
        2 * fromOptimal
    }

    var opacity: Double {
        max(0, 1 - 2 * abs(fromOptimal))
    }

    // Between 0 and 0.5
    var fromOptimal: Double {
        gameHO.lifeOptimal.value - gameHO.lifeStage.value
    }
}

class HoldGameHOVM: GameHOVM<HoldGameHO> {
    var ringScale: Double {
        if gameHO.lifeStage.value >= gameHO.optimalStageStart.value {
            return 0
        }

        return (gameHO.optimalStageStart.value - gameHO.lifeStage.value) / gameHO.optimalStageStart.value
    }

    var opacity: Double {
        if gameHO.lifeStage.value >= gameHO.optimalStageStart.value
            && gameHO.lifeStage.value <= gameHO.optimalStageEnd.value {
            return 1
        }

        if gameHO.lifeStage.value < gameHO.optimalStageStart.value {
            return gameHO.lifeStage.value / gameHO.optimalStageStart.value
        }

        return (LifeStage.endStage.value - gameHO.lifeStage.value)
            / (LifeStage.endStage.value - gameHO.optimalStageEnd.value)
    }
}

class SlideGameHOVM: GameHOVM<SlideGameHO> {
    var ringScale: Double {
        if gameHO.lifeStage.value >= gameHO.optimalStageStart.value {
            return 0
        }

        return (gameHO.optimalStageStart.value - gameHO.lifeStage.value) / gameHO.optimalStageStart.value
    }

    var opacity: Double {
        if gameHO.lifeStage.value >= gameHO.optimalStageStart.value
            && gameHO.lifeStage.value <= gameHO.optimalStageEnd.value {
            return 1
        }

        if gameHO.lifeStage.value < gameHO.optimalStageStart.value {
            return gameHO.lifeStage.value / gameHO.optimalStageStart.value
        }

        return (LifeStage.endStage.value - gameHO.lifeStage.value)
            / (LifeStage.endStage.value - gameHO.optimalStageEnd.value)
    }
}
