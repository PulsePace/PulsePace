//
//  CanvasView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/15.
//

import SwiftUI

struct CanvasView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(beatmapDesigner.hitObjects.toArray(), id: \.id) { hitObject in
                    renderHitObject(hitObject, spacing: beatmapDesigner.gridSpacing)
                }
                if let hitObject = beatmapDesigner.previewHitObject {
                    renderHitObject(hitObject, spacing: beatmapDesigner.gridSpacing)
                }
                renderGrid()
            }
            .offset(beatmapDesigner.gridOffset)
            .onChange(of: geometry.size, perform: { size in
                beatmapDesigner.initialiseFrame(size: size)
            })
        }
        .contentShape(Rectangle())
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .modifier(EditModeModifier(
            beatmapDesigner: beatmapDesigner,
            gestureHandler: beatmapDesigner.gestureHandler
        ))
    }

    @ViewBuilder
    private func renderGrid() -> some View {
        let height = beatmapDesigner.gridHeight
        let width = beatmapDesigner.gridWidth
        let spacing = beatmapDesigner.gridSpacing

        Path { path in
            for index in 0...Int(16) {
                let hOffset = CGFloat(index) * spacing
                path.move(to: CGPoint(x: hOffset, y: 0))
                path.addLine(to: CGPoint(x: hOffset, y: height))
            }
            for index in 0...Int(12) {
                let vOffset = CGFloat(index) * spacing
                path.move(to: CGPoint(x: 0, y: vOffset))
                path.addLine(to: CGPoint(x: width, y: vOffset))
            }
        }
        .stroke(.white.opacity(0.4))

        Path { path in
            let hOffset = 8 * spacing
            path.move(to: CGPoint(x: hOffset, y: 0))
            path.addLine(to: CGPoint(x: hOffset, y: height))
            let vOffset = 6 * spacing
            path.move(to: CGPoint(x: 0, y: vOffset))
            path.addLine(to: CGPoint(x: width, y: vOffset))
        }
        .stroke(.white)
    }

    private func renderHitObject(
        _ hitObject: any HitObject,
        spacing: CGFloat
    ) -> some View {
        let cursorTime = beatmapDesigner.sliderValue + beatmapDesigner.offset
        return ViewFactoryCreator().createCanvasView(
            for: hitObject,
            at: cursorTime,
            with: spacing
        )
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
