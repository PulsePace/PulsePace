//
//  TapHitObject.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import Foundation

class TapHitObject: HitObject {
    var position: CGPoint
    var startTime: Double
    var endTime: Double

    init(position: CGPoint, startTime: Double) {
        self.position = position
        self.startTime = startTime
        self.endTime = startTime
    }
}
