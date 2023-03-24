//
//  CGPoint+Utility.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/16.
//

import Foundation
import SwiftUI

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }

    func translate(by vector: CGVector) -> CGPoint {
        let x = self.x + vector.dx
        let y = self.y + vector.dy

        return CGPoint(x: x, y: y)
    }
}
