//
//  HoldHitObject.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/17.
//

import Foundation

class HoldHitObject: HitObject {
    var position: CGPoint
    var beat: Double
    var endBeat: Double

    var duration: Double {
        endBeat - beat
    }

    init(position: CGPoint, beat: Double, endBeat: Double) {
        self.position = position
        self.beat = beat
        self.endBeat = endBeat
    }
}
