//
//  HoldHitObject.swift
//  PulsePace
//
//  Created by James Chiu on 15/3/23.
//

import Foundation

class HoldHitObject: HitObject {
    var position: CGPoint
    var beat: Double
    var duration: Double

    init(position: CGPoint, beat: Double, duration: Double) {
        self.position = position
        self.beat = beat
        self.duration = duration
    }
}
