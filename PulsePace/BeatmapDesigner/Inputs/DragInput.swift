//
//  DragInput.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

import SwiftUI

class DragInput: TouchInput {
    typealias InputGesture = DragGesture
    var gesture = DragGesture(coordinateSpace: .local)
}
