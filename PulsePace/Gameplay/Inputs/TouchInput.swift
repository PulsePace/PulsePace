//
//  TouchInput.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import CoreGraphics
import SwiftUI

protocol TouchInput {
    associatedtype InputGesture: Gesture
    var gesture: InputGesture { get set }
}
