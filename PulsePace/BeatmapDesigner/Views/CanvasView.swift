//
//  CanvasView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/15.
//

import SwiftUI

struct CanvasView: View {
    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel

    var body: some View {
        ZStack {
            ForEach(beatmapDesigner.hitObjects.toArray(), id: \.id) { hitObject in
                renderHitObject(hitObject)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(.black)
        .onTapGesture { position in
            let interval = 1 / (beatmapDesigner.bps * beatmapDesigner.divisor)
            let beat = ((beatmapDesigner.sliderValue - beatmapDesigner.offset) / interval).rounded()
            beatmapDesigner.hitObjects.enqueue(TapHitObject(position: position, beat: beat * interval))
        }
    }

    private func renderHitObject(_ hitObject: any HitObject) -> some View {
        let absoluteTime = hitObject.beat - beatmapDesigner.sliderValue + beatmapDesigner.offset
        return ZStack {
            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: min(800, max(100, 100 + 200 * absoluteTime)),
                       height: min(800, max(100, 100 + 200 * absoluteTime)))
                .position(x: hitObject.position.x,
                          y: hitObject.position.y)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: hitObject.position.x,
                          y: hitObject.position.y) // TODO: constants

        }
        .opacity(max(0, 1 - 0.5 * abs(absoluteTime)))
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
