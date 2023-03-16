//
//  Math.swift
//  PulsePace
//
//  Created by James Chiu on 15/3/23.
//

import Foundation

final class Math {
    static func deg2Rad(_ deg: CGFloat) -> CGFloat {
        deg / 180 * CGFloat.pi
    }

    static func rad2Deg(_ rad: CGFloat) -> CGFloat {
        rad / CGFloat.pi * 180
    }

    static func sign(_ num: CGFloat) -> Int {
        num == 0 ? 0 : num > 0 ? 1 : -1
    }

    static func clamp(num: CGFloat, minimum: CGFloat, maximum: CGFloat) -> CGFloat {
        min(maximum, max(minimum, num))
    }
}
