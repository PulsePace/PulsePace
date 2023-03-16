//
//  CanvasTapInput.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

import SwiftUI

class CanvasTapInput: TouchInput {
    typealias InputGesture = SpatialTapGesture
    var gesture = SpatialTapGesture(count: 1, coordinateSpace: .local)
}
