//
//  ViewFactoryCreator.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import Foundation
import SwiftUI

class ViewFactoryCreator {
    func createTimelineView(for object: any HitObject, with beatOffset: Double, and zoom: Double) -> some View {
        if let tapHitObject = object as? TapHitObject {
            return AnyView(TapHitObjectViewFactory()
                .createTimelineView(for: tapHitObject, with: beatOffset, and: zoom)
            )
        } else if let slideHitObject = object as? SlideHitObject {
            return AnyView(SlideHitObjectViewFactory()
                .createTimelineView(for: slideHitObject, with: beatOffset, and: zoom)
            )
        } else if let holdHitObject = object as? HoldHitObject {
            return AnyView(HoldHitObjectViewFactory()
                .createTimelineView(for: holdHitObject, with: beatOffset, and: zoom)
            )
        }
        fatalError("Unknown hit object type")
    }

    func createCanvasView(for object: any HitObject, at cursorTime: Double) -> some View {
        if let tapHitObject = object as? TapHitObject {
            return AnyView(TapHitObjectViewFactory().createCanvasView(for: tapHitObject, at: cursorTime))
        } else if let slideHitObject = object as? SlideHitObject {
            return AnyView(SlideHitObjectViewFactory().createCanvasView(for: slideHitObject, at: cursorTime))
        } else if let holdHitObject = object as? HoldHitObject {
            return AnyView(HoldHitObjectViewFactory().createCanvasView(for: holdHitObject, at: cursorTime))
        }
        fatalError("Unknown hit object type")
    }
}
