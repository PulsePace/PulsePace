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
    var endTime: Double

    init(position: CGPoint, beat: Double, endTime: Double) {
        self.position = position
        self.beat = beat
        self.endTime = endTime
    }
}
