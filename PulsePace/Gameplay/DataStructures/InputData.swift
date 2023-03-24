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
    var timeReceived: Double = 0
    var translation = CGSize.zero

    init(value: any Locatable) {
        if let translatedValue = value as? Translatable {
            translation = translatedValue.translation
        }
        location = value.location
    }
}
