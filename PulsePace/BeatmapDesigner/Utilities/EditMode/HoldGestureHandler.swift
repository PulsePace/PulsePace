//
//  HoldGestureHandler.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import Foundation
import SwiftUI

class HoldGestureHandler: GestureHandler {
    typealias InputGesture = _EndedGesture<_ChangedGesture<DragGesture>>
    weak var beatmapDesigner: BeatmapDesignerViewModel?
    let title = "Hold"

    var startTime: Double?
    var isHolding = false

    var gesture: InputGesture {
        DragGesture(minimumDistance: 0)
            .onChanged { [self] value in
                onChanged(position: value.location)
            }
            .onEnded { [self] value in
                onEnded(position: value.location)
            }
    }

    private func resetState() {
        isHolding = false
        startTime = nil
    }

    private func onChanged(position: CGPoint) {
        guard let beatmapDesigner = beatmapDesigner,
              !isHolding,
              beatmapDesigner.isValidPosition(position) else {
            beatmapDesigner?.resetPreviewHitObject()
            return
        }
        initialisePreviewHitObject(
            beatmapDesigner: beatmapDesigner,
            position: beatmapDesigner.virtualisePosition(position)
        )
    }

    private func initialisePreviewHitObject(beatmapDesigner: BeatmapDesignerViewModel, position: CGPoint) {
        isHolding = true
        startTime = beatmapDesigner.quantisedTime

        let hitObject = HoldHitObject(
            position: position,
            startTime: beatmapDesigner.quantisedTime,
            endTime: beatmapDesigner.quantisedTime
        )
        beatmapDesigner.holdPreviewHitObject(hitObject: hitObject)
    }

    private func onEnded(position: CGPoint) {
        guard let beatmapDesigner = beatmapDesigner,
              beatmapDesigner.isValidPosition(position) else {
            return
        }
        registerPreviewHitObject(
            beatmapDesigner: beatmapDesigner,
            position: beatmapDesigner.virtualisePosition(position)
        )
        resetState()
    }

    private func registerPreviewHitObject(beatmapDesigner: BeatmapDesignerViewModel, position: CGPoint) {
        guard let startTime = startTime else {
            return
        }

        let hitObject = HoldHitObject(
            position: position,
            startTime: startTime,
            endTime: beatmapDesigner.quantisedTime
        )
        beatmapDesigner.holdPreviewHitObject(hitObject: hitObject)
        beatmapDesigner.registerPreviewHitObject()
    }
}
