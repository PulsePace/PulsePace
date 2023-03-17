//
//  EditModeModifier.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/16.
//

import Foundation
import SwiftUI

protocol EditModeModifier: ViewModifier {
    var beatmapDesigner: BeatmapDesignerViewModel { get }
}

struct TapEditModeModifier: EditModeModifier {
    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let interval = 1 / (beatmapDesigner.bps * beatmapDesigner.divisor)
                        let beat = ((beatmapDesigner.sliderValue - beatmapDesigner.offset) / interval).rounded()
                        beatmapDesigner.previewHitObject = TapHitObject(position: value.location, beat: beat * interval)
                    }
                    .onEnded { _ in
                        beatmapDesigner.registerPreviewHitObject()
                    }
            )
    }
}

struct SlideEditModeModifier: EditModeModifier {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel
    @State var lastPosition: CGPoint?
    @State var quantisedPosition: CGPoint?
    @State var quantisedTime: Double?
    @State var vertices: [CGPoint] = []
    @State var startPosition: CGPoint?
    @State var startBeat: Double?
    @State var endTime: Double?

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let interval = 1 / (beatmapDesigner.bps * beatmapDesigner.divisor)
                        let beat = ((beatmapDesigner.sliderValue - beatmapDesigner.offset) / interval).rounded()
                        guard let lastPosition = lastPosition else {
                            audioManager.player?.pause()
                            quantisedPosition = value.location
                            quantisedTime = beat * interval
                            startPosition = value.location
                            startBeat = beat * interval
                            endTime = beat * interval
                            beatmapDesigner.previewHitObject = SlideHitObject(
                                position: value.location,
                                beat: beat * interval,
                                endTime: beat * interval,
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
                                endTime: endTime,
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
                            endTime: endTime + quantisedTime,
                            vertices: vertices + [quantisedPosition]
                        )
                    }
                    .onEnded { value in
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
                            audioManager.player?.play()
                        } else {
                            self.lastPosition = quantisedPosition
                            self.endTime? += quantisedTime
                            vertices.append(quantisedPosition)
                        }
                    }
            )
    }
}
