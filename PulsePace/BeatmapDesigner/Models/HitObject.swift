//
//  HitObject.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import Foundation

protocol HitObject: AnyObject, Identifiable {
    var position: CGPoint { get set }
    var startTime: Double { get set }
    var endTime: Double { get set }
}

// MARK: - Identifiable
extension HitObject {
    var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}

protocol SerializedHO: Codable {
    associatedtype HOType: HitObject
    var position: CGPoint { get set }
    var startTime: Double { get set }
    var endTime: Double { get set }

    func deserialize() -> HOType
}

struct SerializedTapHO: SerializedHO {
    typealias HOType = TapHitObject
    var position: CGPoint
    var startTime: Double
    var endTime: Double

    init(tapHO: TapHitObject) {
        position = tapHO.position
        startTime = tapHO.startTime
        endTime = tapHO.endTime
    }

    func deserialize() -> TapHitObject {
        TapHitObject(position: position, startTime: startTime)
    }
}

struct SerializedSlideHO: SerializedHO {
    typealias HOType = SlideHitObject
    var position: CGPoint
    var startTime: Double
    var endTime: Double
    var vertices: [CGPoint]

    init(slideHO: SlideHitObject) {
        position = slideHO.position
        startTime = slideHO.startTime
        endTime = slideHO.endTime
        vertices = slideHO.vertices
    }

    func deserialize() -> SlideHitObject {
        SlideHitObject(position: position, startTime: startTime, endTime: endTime, vertices: vertices)
    }
}

struct SerializedHoldHO: SerializedHO {
    typealias HOType = HoldHitObject
    var position: CGPoint
    var startTime: Double
    var endTime: Double

    init(holdHO: HoldHitObject) {
        position = holdHO.position
        startTime = holdHO.startTime
        endTime = holdHO.endTime
    }

    func deserialize() -> HoldHitObject {
        HoldHitObject(position: position, startTime: startTime, endTime: endTime)
    }
}
