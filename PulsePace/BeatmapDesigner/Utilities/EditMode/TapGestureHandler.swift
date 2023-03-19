//
//  TapGestureHandler.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import Foundation
import SwiftUI

class TapGestureHandler: GestureHandler {
    typealias InputGesture = _EndedGesture<_ChangedGesture<DragGesture>>
    weak var beatmapDesigner: BeatmapDesignerViewModel?
    let title = "Tap"

    var gesture: InputGesture {
        DragGesture(minimumDistance: 0)
            .onChanged { [self] value in
                onChanged(position: value.location)
            }
            .onEnded { [self] _ in
                onEnded()
            }
    }

    private func onChanged(position: CGPoint) {
        guard let beatmapDesigner = beatmapDesigner else {
            return
        }
        beatmapDesigner.previewHitObject = TapHitObject(
            position: position,
            startTime: beatmapDesigner.quantisedTime
        )
    }

    private func onEnded() {
        guard let beatmapDesigner = beatmapDesigner else {
            return
        }
        beatmapDesigner.registerPreviewHitObject()
    }
}
