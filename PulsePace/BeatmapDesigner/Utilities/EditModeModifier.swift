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
    @State var quantisedPosition: CGPoint?
    @State var lastPosition: CGPoint?
    @State var vertices: [CGPoint] = []

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        guard let lastPosition = lastPosition else {
                            quantisedPosition = value.location
                            return
                        }
                        let speed: Double = 50 // TODO: constants
                        let interval = 1 / (beatmapDesigner.bps * beatmapDesigner.divisor)
                        let distanceUnit = interval * speed
                        let quantisedDistance = floor(value.location.distance(to: lastPosition) / distanceUnit) * distanceUnit
                        quantisedPosition = lastPosition
                            .translate(by: CGVector(from: lastPosition, to: value.location)
                                .normalise
                                .scale(by: quantisedDistance)
                            )
                        print(quantisedPosition)
//                        let beat = ((beatmapDesigner.sliderValue - beatmapDesigner.offset) / interval).rounded()
//                        beatmapDesigner.previewHitObject = TapHitObject(position: value.location, beat: beat * interval)
                    }
                    .onEnded { value in
                        guard let lastPosition = lastPosition else {
                            lastPosition = value.location
                            vertices.append(value.location)
                            return
                        }

                        if value.location.distance(to: lastPosition) <= 50 {
                            beatmapDesigner.registerPreviewHitObject()
                        } else {

                        }
                    }
            )
            .onTapGesture { position in
                vertices.append(position)
                audioManager.player?.pause()
//                vertices.append(position)
//                if let lastPosition = lastPosition, position.distance(to: lastPosition) <= 50 {
//
//                }
//                if value.isMultiple(of: 2) {
//                    print(123)
//                }
//                lastPosition += 1
//                vertices.append(.zero)
//                let interval = 1 / (beatmapDesigner.bps * beatmapDesigner.divisor)
//                let beat = ((beatmapDesigner.sliderValue - beatmapDesigner.offset) / interval).rounded()
//                beatmapDesigner.hitObjects.append(TapHitObject(position: position, beat: beat * interval))
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        value.location
                    }
            )
    }
}
