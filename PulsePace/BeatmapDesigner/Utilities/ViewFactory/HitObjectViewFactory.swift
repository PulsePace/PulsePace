//
//  HitObjectViewFactory.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/16.
//

import Foundation
import SwiftUI

protocol HitObjectViewFactory {
    associatedtype Object: HitObject
    associatedtype TimelineView: HitObjectTimelineView
    associatedtype CanvasView: HitObjectCanvasView

    func createTimelineView(for object: Object, with beatOffset: Double, and zoom: Double) -> TimelineView
    func createCanvasView(for object: Object, at cursorTime: Double, with spacing: CGFloat) -> CanvasView
}
