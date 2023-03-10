//
//  SpinInput.swift
//  PulsePace
//
//  Created by Charisma Kausar on 8/3/23.
//

import SwiftUI

struct SpinInput: TouchInput {
    typealias InputGesture = DragGesture
    var gesture = DragGesture(minimumDistance: 50)
}
