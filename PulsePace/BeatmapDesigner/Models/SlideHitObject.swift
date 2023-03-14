//
//  SlideHitObjec.swift
//  PulsePace
//
//  Created by James Chiu on 15/3/23.
//

import Foundation

class SlideHitObject: HitObject {
    var position: CGPoint
    var beat: Double
    var endPosition: CGPoint

    init(position: CGPoint, beat: Double, endPosition: CGPoint) {
        self.position = position
        self.beat = beat
        self.endPosition = endPosition
    }
}
