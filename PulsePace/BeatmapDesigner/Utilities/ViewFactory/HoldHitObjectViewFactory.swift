//
//  HoldHitObjectViewFactory.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import Foundation

class HoldHitObjectViewFactory: HitObjectViewFactory {
    func createTimelineView(
        for object: HoldHitObject,
        with beatOffset: Double,
        and zoom: Double
    ) -> HoldHitObjectTimelineView {
        HoldHitObjectTimelineView(object: object, beatOffset: beatOffset, zoom: zoom)
    }

    func createCanvasView(for object: HoldHitObject, at cursorTime: Double) -> HoldHitObjectCanvasView {
        HoldHitObjectCanvasView(object: object, cursorTime: cursorTime)
    }
}
