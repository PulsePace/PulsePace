//
//  SlideCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//
import simd

class SlideCommand: InputCommand {
    override private init(action: @escaping InputCommand.Action, completion: InputCommand.Action? = nil) {
        super.init(action: action, completion: completion)
    }

    convenience init() {
        self.init { _ in
            print("Slide")
        }
    }
}

class SlideCommandHO: CommandHO {
    typealias GameHOType = SlideGameHO
    var shouldExecute = false
    var currInput: InputData?
    // Sample between 0 and 1, higher the better perfect is a 1
    var proximityScore: Double = 0
    // Proximity of input must be within this distance of expected position of slider to contribute to proximity score
    var minimumProximity: Double = 30

    func execute(gameHO: SlideGameHO, deltaTime: Double) {
        guard let currInput = currInput else {
            print("should execute should have guarded against execute")
            return
        }
        let error = simd_length(SIMD2(
            x: currInput.location.x - gameHO.expectedPosition.x,
            y: currInput.location.y - gameHO.expectedPosition.y
        ))
        let clampedError = Math.clamp(num: error, minimum: 0, maximum: minimumProximity) / minimumProximity
        // compare expected position to currInput
        proximityScore = Math.clamp(
            num: proximityScore + (1 - clampedError) * deltaTime / gameHO.optimalLife,
            minimum: 0,
            maximum: 1
        )
    }
}
