//
//  TapHitObjectViewFactory.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import Foundation

class TapHitObjectViewFactory: HitObjectViewFactory {
    func createTimelineView(
        for object: TapHitObject,
        with beatOffset: Double,
        and zoom: Double
    ) -> TapHitObjectTimelineView {
        TapHitObjectTimelineView(object: object, beatOffset: beatOffset, zoom: zoom)
    }

    func createCanvasView(
        for object: TapHitObject,
        at cursorTime: Double,
        with spacing: CGFloat
    ) -> TapHitObjectCanvasView {
        TapHitObjectCanvasView(object: object, cursorTime: cursorTime, spacing: spacing)
    }
}
