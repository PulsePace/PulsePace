//
//  SlideGestureHandler.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import Foundation
import SwiftUI

class SlideGestureHandler: GestureHandler {
    typealias InputGesture = _EndedGesture<_ChangedGesture<DragGesture>>
    weak var beatmapDesigner: BeatmapDesignerViewModel?
    let title = "Slide"

    var lastPosition: CGPoint?
    var quantisedPosition: CGPoint?
    var quantisedTime: Double?
    var vertices: [CGPoint] = []
    var startPosition: CGPoint?
    var startTime: Double?
    var endTime: Double?

    var gesture: InputGesture {
        DragGesture(minimumDistance: 0)
            .onChanged { [self] value in
                onChanged(position: value.location)
            }
            .onEnded { [self] value in
                onEnded(position: value.location)
            }
    }

    private func onChanged(position: CGPoint) {
        guard let beatmapDesigner = beatmapDesigner,
              beatmapDesigner.isValidPosition(position) else {
            return
        }
        guard let lastPosition = lastPosition else {
            initialisePreviewHitObject(
                beatmapDesigner: beatmapDesigner,
                position: beatmapDesigner.virtualisePosition(position)
            )
            return
        }
        let virtualPosition = beatmapDesigner.virtualisePosition(position)
        guard virtualPosition.distance(to: lastPosition) > 50 else {
            unsetPreviewHitObject(beatmapDesigner: beatmapDesigner)
            return
        }
        guard beatmapDesigner.isValidPosition(position) else {
            return
        }
        setPreviewHitObject(
            beatmapDesigner: beatmapDesigner,
            position: beatmapDesigner.virtualisePosition(position)
        )
    }

    private func initialisePreviewHitObject(beatmapDesigner: BeatmapDesignerViewModel, position: CGPoint) {
        quantisedPosition = position
        quantisedTime = beatmapDesigner.quantisedTime
        startPosition = position
        startTime = beatmapDesigner.quantisedTime
        endTime = beatmapDesigner.quantisedTime

        let hitObject = SlideHitObject(
            position: position,
            startTime: beatmapDesigner.quantisedTime,
            endTime: beatmapDesigner.quantisedTime,
            vertices: vertices
        )
        beatmapDesigner.holdPreviewHitObject(hitObject: hitObject)
    }

    private func unsetPreviewHitObject(beatmapDesigner: BeatmapDesignerViewModel) {
        guard let startBeat = startTime,
              let startPosition = startPosition,
              let endTime = endTime else {
            return
        }

        let hitObject = SlideHitObject(
            position: startPosition,
            startTime: startBeat,
            endTime: endTime,
            vertices: vertices
        )
        beatmapDesigner.holdPreviewHitObject(hitObject: hitObject)
    }

    private func setPreviewHitObject(beatmapDesigner: BeatmapDesignerViewModel, position: CGPoint) {
        guard let startBeat = startTime,
              let startPosition = startPosition,
              let endTime = endTime,
              let lastPosition = lastPosition else {
            return
        }

        let speed: Double = 200 // TODO: constants
        let distanceUnit = beatmapDesigner.interval * speed
        let quantisedDistance = floor(position.distance(to: lastPosition) / distanceUnit) * distanceUnit
        let quantisedTime = quantisedDistance / speed
        let quantisedPosition = lastPosition
            .translate(by: CGVector(from: lastPosition, to: position)
                .normalise
                .scale(by: quantisedDistance)
            )

        self.quantisedPosition = quantisedPosition
        self.quantisedTime = quantisedTime

        let hitObject = SlideHitObject(
            position: startPosition,
            startTime: startBeat,
            endTime: endTime + quantisedTime,
            vertices: vertices + [quantisedPosition]
        )
        beatmapDesigner.holdPreviewHitObject(hitObject: hitObject)
    }

    private func onEnded(position: CGPoint) {
        guard let beatmapDesigner = beatmapDesigner,
              beatmapDesigner.isValidPosition(position) else {
            return
        }
        guard let quantisedPosition = quantisedPosition,
              let quantisedTime = quantisedTime else {
            return
        }
        guard let lastPosition = lastPosition, endTime != nil else {
            lastPosition = quantisedPosition
            return
        }
        let virtualPosition = beatmapDesigner.virtualisePosition(position)
        if virtualPosition.distance(to: lastPosition) <= 50 {
            beatmapDesigner.registerPreviewHitObject()
            resetState()
        } else {
            addVertex(quantisedTime: quantisedTime, quantisedPosition: quantisedPosition)
        }
    }

    private func resetState() {
        lastPosition = nil
        quantisedPosition = nil
        vertices = []
        startPosition = nil
        startTime = nil
    }

    private func addVertex(quantisedTime: Double, quantisedPosition: CGPoint) {
        lastPosition = quantisedPosition
        endTime? += quantisedTime
        vertices.append(quantisedPosition)
    }
}
