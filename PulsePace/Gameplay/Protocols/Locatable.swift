//
//  Locatable.swift
//  PulsePace
//
//  Created by Charisma Kausar on 10/3/23.
//

import CoreGraphics
import SwiftUI

protocol Locatable {
    var location: CGPoint { get }
}

extension SpatialTapGesture.Value: Locatable {}
extension DragGesture.Value: Locatable {}
