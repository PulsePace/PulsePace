//
//  BeatmapDesignerView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import SwiftUI
import AVKit

struct StartButtonView: View {
    @Binding var path: [Page]
    @EnvironmentObject var gameVM: GameViewModel
    @EnvironmentObject var designerVM: BeatmapDesignerViewModel

    var body: some View {
        Button(action: {
            path.append(Page.playPage)
            gameVM.initEngineWithBeatmap(designerVM.beatmap)
        }) {
            Text("Start")
                .font(.title2)
        }
    }
}

struct BeatmapDesignerView: View {
    @EnvironmentObject var audioManager: AudioManager
    @StateObject var viewModel = BeatmapDesignerViewModel()
    @Binding var path: [Page]

    var body: some View {
        VStack {
            HStack {
                ZoomButtonsView()
                TimelineView()
                DivisorSliderView()
                StartButtonView(path: $path)
            }

            HStack {
                VStack {
                    ForEach(viewModel.gestureHandlerList, id: \.title) { gestureHandler in
                        Button(action: {
                            viewModel.gestureHandler = gestureHandler
                        }) {
                            Text(gestureHandler.title)
                        }
                    }
                }

                CanvasView()
            }

            PlaybackControlView()
        }
        .onAppear {
            audioManager.startPlayer(track: "test")
            if let player = audioManager.player {
                viewModel.initialisePlayer(player: player)
            }
        }
        .onDisappear {
            audioManager.stopPlayer()
        }
        .environmentObject(viewModel)
    }
}

// struct BeatmapDesignerView_Previews: PreviewProvider {
//    static var previews: some View {
//        BeatmapDesignerView(viewModel: BeatmapDesignerViewModel())
//            .previewInterfaceOrientation(.landscapeLeft)
//    }
// }
