//
//  BeatmapDesignerView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import SwiftUI
import AVKit

struct BeatmapDesignerView: View {
    @EnvironmentObject var audioManager: AudioManager
    @StateObject var viewModel: BeatmapDesignerViewModel

    init(viewModel: BeatmapDesignerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            HStack {
                ZoomButtonsView()
                TimelineView()
                DivisorSliderView()
            }
            .zIndex(.infinity)

            CanvasView()

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

struct BeatmapDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        BeatmapDesignerView(viewModel: BeatmapDesignerViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
