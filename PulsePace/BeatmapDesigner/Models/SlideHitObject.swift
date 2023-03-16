//
//  SlideHitObject.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/16.
//

import Foundation

class SlideHitObject: HitObject {
    var position: CGPoint
    var beat: Double
    var vertices: [CGPoint]

    init(position: CGPoint, beat: Double, vertices: [CGPoint]) {
        self.position = position
        self.beat = beat
        self.vertices = vertices
    }
}
