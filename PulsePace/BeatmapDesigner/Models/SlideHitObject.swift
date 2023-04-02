//
//  SlideHitObject.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/16.
//

import Foundation

class SlideHitObject: HitObject {
    typealias SerialType = SerializedSlideHO
    var position: CGPoint
    var startTime: Double
    var endTime: Double
    var vertices: [CGPoint]

    var endPosition: CGPoint {
        vertices.last ?? .zero // TODO: hacky
    }

    init(position: CGPoint, startTime: Double, endTime: Double, vertices: [CGPoint]) {
        self.position = position
        self.startTime = startTime
        self.endTime = endTime
        self.vertices = vertices
    }

    func serialize() -> SerializedSlideHO {
        SerializedSlideHO(slideHO: self)
    }
}
