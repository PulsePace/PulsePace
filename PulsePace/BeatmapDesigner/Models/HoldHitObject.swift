//
//  HoldHitObject.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/17.
//

import Foundation

class HoldHitObject: HitObject {
    var position: CGPoint
    var startTime: Double
    var endTime: Double

    var duration: Double {
        endTime - startTime
    }

    init(position: CGPoint, startTime: Double, endTime: Double) {
        self.position = position
        self.startTime = startTime
        self.endTime = endTime
    }
}
