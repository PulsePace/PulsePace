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
    var endBeat: Double
    var vertices: [CGPoint]

    var endPosition: CGPoint {
        vertices.last ?? .zero // TODO: hacky
    }

    init(position: CGPoint, beat: Double, endBeat: Double, vertices: [CGPoint]) {
        self.position = position
        self.beat = beat
        self.endBeat = endBeat
        self.vertices = vertices
    }
}
