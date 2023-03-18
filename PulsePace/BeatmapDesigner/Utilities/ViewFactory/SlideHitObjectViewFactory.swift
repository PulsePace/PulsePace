//
//  SlideHitObjectViewFactory.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import Foundation

class SlideHitObjectViewFactory: HitObjectViewFactory {
    func createTimelineView(
        for object: SlideHitObject,
        with beatOffset: Double,
        and zoom: Double
    ) -> SlideHitObjectTimelineView {
        SlideHitObjectTimelineView(object: object, beatOffset: beatOffset, zoom: zoom)
    }

    func createCanvasView(for object: SlideHitObject, at cursorTime: Double) -> SlideHitObjectCanvasView {
        SlideHitObjectCanvasView(object: object, cursorTime: cursorTime)
    }
}
