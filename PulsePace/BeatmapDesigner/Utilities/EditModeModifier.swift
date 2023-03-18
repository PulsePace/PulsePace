//
//  EditModeModifier.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/16.
//

import Foundation
import SwiftUI

protocol GestureHandler {
    associatedtype InputGesture: Gesture
    var beatmapDesigner: BeatmapDesignerViewModel? { get set }
    var gesture: InputGesture { get }
    var title: String { get }
}

struct EditModeModifier: ViewModifier {
    var gestureHandler: any GestureHandler

    init(beatmapDesigner: BeatmapDesignerViewModel, gestureHandler: any GestureHandler) {
        self.gestureHandler = gestureHandler
        self.gestureHandler.beatmapDesigner = beatmapDesigner
    }

    func body(content: Content) -> some View {
        AnyView(content.gesture(gestureHandler.gesture))
    }
}

class TapGestureHandler: GestureHandler {
    typealias InputGesture = _EndedGesture<_ChangedGesture<DragGesture>>
    weak var beatmapDesigner: BeatmapDesignerViewModel?
    let title = "Tap"

    var gesture: InputGesture {
        DragGesture(minimumDistance: 0)
            .onChanged { [self] value in
                guard let beatmapDesigner = beatmapDesigner else {
                    return
                }
                let interval = 1 / (beatmapDesigner.bps * beatmapDesigner.divisor)
                let beat = ((beatmapDesigner.sliderValue - beatmapDesigner.offset) / interval).rounded()
                beatmapDesigner.previewHitObject = TapHitObject(position: value.location, beat: beat * interval)
            }
            .onEnded { [self] _ in
                guard let beatmapDesigner = beatmapDesigner else {
                    return
                }
                beatmapDesigner.registerPreviewHitObject()
            }
    }
}

class HoldGestureHandler: GestureHandler {
    typealias InputGesture = _EndedGesture<_ChangedGesture<DragGesture>>
    weak var beatmapDesigner: BeatmapDesignerViewModel?
    let title = "Hold"
    var startTime: Double?
    var isHolding = false

    var gesture: InputGesture {
        DragGesture(minimumDistance: 0)
            .onChanged { [self] value in
                guard let beatmapDesigner = beatmapDesigner else {
                    return
                }
                let interval = 1 / (beatmapDesigner.bps * beatmapDesigner.divisor)
                let beat = ((beatmapDesigner.sliderValue - beatmapDesigner.offset) / interval).rounded()
                if !isHolding {
                    isHolding = true
                    startTime = beat * interval
                    beatmapDesigner.previewHitObject = HoldHitObject(
                        position: value.location,
                        beat: beat * interval,
                        endBeat: beat * interval
                    )
                }
            }
            .onEnded { [self] value in
                guard let beatmapDesigner = beatmapDesigner else {
                    return
                }
                let interval = 1 / (beatmapDesigner.bps * beatmapDesigner.divisor)
                let beat = ((beatmapDesigner.sliderValue - beatmapDesigner.offset) / interval).rounded()
                guard let startTime = startTime else {
                    return
                }
                beatmapDesigner.previewHitObject = HoldHitObject(
                    position: value.location,
                    beat: startTime,
                    endBeat: beat * interval
                )
                beatmapDesigner.registerPreviewHitObject()
                isHolding = false
                self.startTime = nil
            }
    }
}

class SlideGestureHandler: GestureHandler {
    typealias InputGesture = _EndedGesture<_ChangedGesture<DragGesture>>
    weak var beatmapDesigner: BeatmapDesignerViewModel?
    let title = "Slide"
    var lastPosition: CGPoint?
    var quantisedPosition: CGPoint?
    var quantisedTime: Double?
    var vertices: [CGPoint] = []
    var startPosition: CGPoint?
    var startBeat: Double?
    var endTime: Double?

    var gesture: InputGesture {
        DragGesture(minimumDistance: 0)
            .onChanged { [self] value in
                guard let beatmapDesigner = beatmapDesigner else {
                    return
                }
                let interval = 1 / (beatmapDesigner.bps * beatmapDesigner.divisor)
                let beat = ((beatmapDesigner.sliderValue - beatmapDesigner.offset) / interval).rounded()
                guard let lastPosition = lastPosition else {
                    quantisedPosition = value.location
                    quantisedTime = beat * interval
                    startPosition = value.location
                    startBeat = beat * interval
                    endTime = beat * interval
                    beatmapDesigner.previewHitObject = SlideHitObject(
                        position: value.location,
                        beat: beat * interval,
                        endBeat: beat * interval,
                        vertices: vertices
                    )
                    return
                }
                guard let startBeat = startBeat,
                      let startPosition = startPosition,
                      let endTime = endTime else {
                    return
                }
                guard value.location.distance(to: lastPosition) > 50 else {
                    beatmapDesigner.previewHitObject = SlideHitObject(
                        position: startPosition,
                        beat: startBeat,
                        endBeat: endTime,
                        vertices: vertices
                    )
                    return
                }
                let speed: Double = 200 // TODO: constants
                let distanceUnit = interval * speed
                let quantisedDistance = floor(value.location.distance(to: lastPosition) / distanceUnit) * distanceUnit
                let quantisedTime = quantisedDistance / speed
                let quantisedPosition = lastPosition
                    .translate(by: CGVector(from: lastPosition, to: value.location)
                        .normalise
                        .scale(by: quantisedDistance)
                    )
                self.quantisedPosition = quantisedPosition
                self.quantisedTime = quantisedTime
                beatmapDesigner.previewHitObject = SlideHitObject(
                    position: startPosition,
                    beat: startBeat,
                    endBeat: endTime + quantisedTime,
                    vertices: vertices + [quantisedPosition]
                )
            }
            .onEnded { [self] value in
                guard let beatmapDesigner = beatmapDesigner else {
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
                if value.location.distance(to: lastPosition) <= 50 {
                    beatmapDesigner.registerPreviewHitObject()
                    self.lastPosition = nil
                    self.quantisedPosition = nil
                    vertices = []
                    self.startPosition = nil
                    self.startBeat = nil
                } else {
                    self.lastPosition = quantisedPosition
                    self.endTime? += quantisedTime
                    vertices.append(quantisedPosition)
                }
            }
    }
}
