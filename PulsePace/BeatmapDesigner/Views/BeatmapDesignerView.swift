//
//  BeatmapDesignerView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import SwiftUI
import AVKit
import PopupView

struct BeatmapDesignerView: View {
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var beatmapManager: BeatmapManager
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var viewModel: BeatmapDesignerViewModel
    @EnvironmentObject var pageList: PageList

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                ZoomButtonsView()
                TimelineView()
                DivisorSliderView()
                VStack(spacing: 4) {
                    renderStartButton()
                    renderSaveButton()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .black.opacity(0.25),
                        .black.opacity(0.225)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )

            ZStack(alignment: .leading) {
                CanvasView()
                ToolButtonsView()
            }
            PlaybackControlView()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    .purple,
                    Color(hex: 0x873EBA)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear {
            if let track = viewModel.songData?.track {
                audioManager.startPlayer(track: track)
            }
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
            viewModel.sliderValue = 0
        }
        .environmentObject(viewModel)
//        .popup(isPresented: $viewModel.isShowing) {
//            Text("The popup")
//                .frame(width: 200, height: 60)
//                .background(Color(red: 0.85, green: 0.8, blue: 0.95))
//                .cornerRadius(30.0)
//        } customize: {
//            $0
//                .type(.default)
////                .type(.floater())
//                .position(.top)
//                .animation(.spring())
//                .dismissSourceCallback {
//                    print($0)
//                }
//                .isOpaque(true)
//                .autohideIn(2)
//        }
    }

    @ViewBuilder
    private func renderStartButton() -> some View {
        Button(action: {
            gameViewModel.selectedGameMode = ModeFactory.defaultMode
            gameViewModel.initEngine(with: viewModel.beatmap)
            pageList.navigate(to: .playPage)
        }) {
            Text("Start")
                .foregroundColor(.white)
                .font(.title2)
        }
    }

    @ViewBuilder
    private func renderSaveButton() -> some View {
        Button(action: {
            Task {
                beatmapManager.saveBeatmap(namedBeatmap: await viewModel.namedBeatmap)
            }
        }) {
            Text("Save")
                .foregroundColor(.white)
                .font(.title2)
        }
    }
}
