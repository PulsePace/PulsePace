//
//  CGVector+Utility.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/16.
//

import Foundation
import SwiftUI

extension CGVector {
    static let xBasis = CGVector(dx: 1, dy: 0)
    static let yBasis = CGVector(dx: 0, dy: 1)

    var length: CGFloat {
        sqrt(dx * dx + dy * dy)
    }

    var normalise: CGVector {
        scale(by: 1 / length)
    }

    init(from source: CGPoint, to destination: CGPoint) {
        let dx = destination.x - source.x
        let dy = destination.y - source.y

        self.init(dx: dx, dy: dy)
    }

    func add(by other: CGVector) -> CGVector {
        let dx = self.dx + other.dx
        let dy = self.dy + other.dy

        return CGVector(dx: dx, dy: dy)
    }

    func subtract(by other: CGVector) -> CGVector {
        add(by: other.scale(by: -1))
    }

    func scale(by value: CGFloat) -> CGVector {
        let dx = self.dx * value
        let dy = self.dy * value

        return CGVector(dx: dx, dy: dy)
    }

    var flip: CGVector {
        scale(by: -1)
    }

    func rotate(by value: CGFloat) -> CGVector {
        let newDx = cos(value) * self.dx - sin(value) * self.dy
        let newDy = sin(value) * self.dx + cos(value) * self.dy
        return CGVector(dx: newDx, dy: newDy)
    }

    func dot(with other: CGVector) -> CGFloat {
        let xs = self.dx * other.dx
        let ys = self.dy * other.dy

        return xs + ys
    }

    func angle(with other: CGVector) -> CGFloat {
        // theta = atan2(ax * by- ay * bx, ax * bx + ay * by)
        return atan2(dx * other.dy - dy * other.dx, dx * other.dx + dy * other.dy)
    }

    func reflectAlongVector(_ vector: CGVector) -> CGVector {
        // r = d - 2 \times (d \dot n) \times n
        let normalised = vector.normalise
        let scale = 2 * dot(with: normalised)
        let reflected = subtract(by: normalised.scale(by: scale))

        return reflected
    }

    func reflectAlongXAxis() -> CGVector {
        reflectAlongVector(CGVector(dx: 1, dy: 0))
    }

    func reflectAlongYAxis() -> CGVector {
        reflectAlongVector(CGVector(dx: 0, dy: 1))
    }

    func project(onto vector: CGVector) -> CGVector {
        vector.normalise.scale(by: dot(with: vector.normalise))
    }
}
