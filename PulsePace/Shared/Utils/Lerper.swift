//
//  Lerper.swift
//  PulsePace
//
//  Created by James Chiu on 15/3/23.
//

import Foundation

final class Lerper {
    static func linearFloat(from: Double, to: Double, t: Double) -> Double {
        let clampedT = Math.clamp(num: t, minimum: 0, maximum: 1)
        return from + (to - from) * clampedT
    }

    static func cubicFloat(from: Double, to: Double, t: Double) -> Double {
        let clampedT = Math.clamp(num: t, minimum: 0, maximum: 1)
        return linearFloat(from: from, to: to, t: 1 + pow(clampedT - 1, 3))
    }

    static func sinFloat(center: Double, maximum: Double, minimum: Double, t: Double) -> Double {
        let clampedT = Math.clamp(num: t, minimum: 0, maximum: 1)
        let intervalPoint = sin(clampedT * 2 * Double.pi)
        if intervalPoint > Double.pi {
            return intervalPoint * (minimum - center) + center
        } else {
            return intervalPoint * (maximum - center) + center
        }
    }

    static func linearVector2(from: CGPoint, to: CGPoint, t: Double) -> CGPoint {
        let clampedT = Math.clamp(num: t, minimum: 0, maximum: 1)
        let x = linearFloat(from: from.x, to: to.x, t: clampedT)
        let y = linearFloat(from: from.y, to: to.y, t: clampedT)
        return CGPoint(x: x, y: y)
    }
}
