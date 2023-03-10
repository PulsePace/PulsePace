//
//  TapInput.swift
//  PulsePace
//
//  Created by Charisma Kausar on 8/3/23.
//

import SwiftUI

class TapInput: TouchInput {
    typealias InputGesture = SpatialTapGesture
    var gesture = SpatialTapGesture(count: 1)
}
