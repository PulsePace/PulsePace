//
//  HitObjectCanvasView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import SwiftUI

protocol HitObjectCanvasView: View {
    var position: CGPoint { get }
    var startTime: Double { get }
    var endTime: Double { get }
}
