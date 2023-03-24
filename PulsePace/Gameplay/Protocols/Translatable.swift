//
//  Translatable.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

import CoreGraphics
import SwiftUI

protocol Translatable: Locatable {
    var translation: CGSize { get }
}

extension DragGesture.Value: Translatable {}
