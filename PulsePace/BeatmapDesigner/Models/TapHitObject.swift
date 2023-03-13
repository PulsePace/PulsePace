//
//  TapHitObject.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import Foundation

class TapHitObject: HitObject {
    var position: CGPoint
    var beat: Double

    init(position: CGPoint, beat: Double) {
        self.position = position
        self.beat = beat
    }
}
