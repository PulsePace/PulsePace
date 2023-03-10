//
//  InputData.swift
//  PulsePace
//
//  Created by Charisma Kausar on 10/3/23.
//

import SwiftUI
import CoreGraphics

struct InputData {
    var location: CGPoint
    var timeReceived: Date

    init(value: any Locatable) {
        location = value.location
        timeReceived = Date.now
    }
}
