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
        if let player = audioManager.player {
            ZStack {
                ForEach(beatmapDesigner.hitObjects.toArray(), id: \.id) { hitObject in
                    renderHitObject(hitObject)
                }
                if let hitObject = beatmapDesigner.previewHitObject {
                    renderHitObject(hitObject)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(.black)
            .modifier(TapEditModeModifier())
        }
    }

    private func renderHitObject(_ hitObject: any HitObject) -> some View {
        let cursorTime = beatmapDesigner.sliderValue + beatmapDesigner.offset
        return ViewFactoryCreator().createCanvasView(for: hitObject, at: cursorTime)
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
