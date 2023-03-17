//
//  GestureHandler.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import Foundation
import SwiftUI

protocol GestureHandler {
    associatedtype InputGesture: Gesture
    var beatmapDesigner: BeatmapDesignerViewModel? { get set }
    var gesture: InputGesture { get }
    var title: String { get }
}
