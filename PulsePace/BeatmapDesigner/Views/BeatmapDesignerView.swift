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

struct SaveButtonView: View {
    @EnvironmentObject var designerVM: BeatmapDesignerViewModel
    @EnvironmentObject var beatmapManager: BeatmapManager

    var body: some View {
        Button(action: {
            beatmapManager.saveBeatmap(namedBeatmap: designerVM.namedBeatmap)
        }) {
            Text("Save")
                .font(.title2)
        }
    }
}

struct BeatmapDesignerView: View {
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var audioManager: AudioManager
    @StateObject var viewModel = BeatmapDesignerViewModel()
    @Binding var path: [Page]

    var body: some View {
        VStack {
            HStack {
                ZoomButtonsView()
                TimelineView()
                DivisorSliderView()
                VStack {
                    StartButtonView(path: $path)
                    SaveButtonView()
                }
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
            viewModel.achievementManager = achievementManager

            let openedPropertyUpdater = achievementManager
                .getPropertyUpdater(for: TotalBeatmapDesignerOpenedProperty.self)
            openedPropertyUpdater.increment()
        }
        .onDisappear {
            audioManager.stopPlayer()
        }
        .environmentObject(viewModel)
    }
}
