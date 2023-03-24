//
//  CGPoint+Hashable.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/17.
//

import Foundation
import SwiftUI

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
