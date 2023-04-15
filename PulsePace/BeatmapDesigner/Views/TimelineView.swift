//
//  TimelineView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/15.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel
    @State var width: CGFloat = 0
    @State var height: CGFloat = 0

    @ViewBuilder
    var body: some View {
        if let player = audioManager.player {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    renderBeatLines(spacing: beatmapDesigner.subBeatSpacing, color: .blue)
                    renderBeatLines(spacing: beatmapDesigner.mainBeatSpacing, color: .white)
                    renderStartLine(color: .red)
                    renderPreviewBeat()
                    renderBeats()
                    renderCursor()
                }
                .frame(width: width)
                .onAppear {
                    self.width = geometry.size.width
                    self.height = geometry.size.height
                }
            }
            .frame(height: 60)
            .background(Color(hex: 0x310067))
            .mask(LinearGradient(
                gradient: Gradient(colors: [.clear] + Array(repeating: Color.black, count: 16) + [.clear]),
                startPoint: .leading,
                endPoint: .trailing
            ))
            .clipped()
            .modifier(GestureModifier(input: DragInput(),
                                      command: RepositionSongCommand(receiver: beatmapDesigner, player: player)))
        }
    }

    @ViewBuilder
    private func renderBeatLines(spacing: CGFloat, color: Color) -> some View {
        Path { path in
            for index in 0...Int(width / (2 * spacing)) {
                let position = CGFloat(index) * spacing
                let offset = (beatmapDesigner.zoom * beatmapDesigner.offset)
                    .remainder(dividingBy: spacing)
                let rightPosition = offset + position
                let leftPosition = offset - position

                path.move(to: CGPoint(x: rightPosition, y: 0))
                path.addLine(to: CGPoint(x: rightPosition, y: height))
                path.move(to: CGPoint(x: leftPosition, y: 0))
                path.addLine(to: CGPoint(x: leftPosition, y: height))
            }
        }
        .stroke(color)
        .offset(x: width / 2 - (beatmapDesigner.zoom * beatmapDesigner.sliderValue)
            .remainder(dividingBy: spacing))
    }

    @ViewBuilder
    private func renderStartLine(color: Color) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
        }
        .stroke(.red)
        .offset(x: width / 2 - (beatmapDesigner.zoom * beatmapDesigner.sliderValue))
    }

    @ViewBuilder
    private func renderPreviewBeat() -> some View {
        let beatOffset = beatmapDesigner.offset - beatmapDesigner.sliderValue
        if let previewHitObject = beatmapDesigner.previewHitObject {
            ViewFactoryCreator().createTimelineView(
                for: previewHitObject,
                with: beatOffset,
                and: beatmapDesigner.zoom
            )
            .offset(x: width / 2 - 20)
        }
    }

    @ViewBuilder
    private func renderBeats() -> some View {
        let beatOffset = beatmapDesigner.offset - beatmapDesigner.sliderValue
        ForEach(beatmapDesigner.hitObjects.toArray(), id: \.id) { hitObject in
            ViewFactoryCreator().createTimelineView(
                for: hitObject,
                with: beatOffset,
                and: beatmapDesigner.zoom
            )
        }
        .offset(x: width / 2 - 20)
    }

    @ViewBuilder
    private func renderCursor() -> some View {
        Rectangle()
            .foregroundColor(.blue)
            .frame(width: 5, height: 60)
            .offset(x: width / 2)
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
