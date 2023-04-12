//
//  BeatmapDesignerView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import SwiftUI
import AVKit

struct BeatmapDesignerView: View {
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var beatmapManager: BeatmapManager
    @EnvironmentObject var gameViewModel: GameViewModel
    @StateObject var viewModel = BeatmapDesignerViewModel()
    @Binding var path: [Page]

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
            AudioManager.shared.playMusic(track: "test", from: String(describing: viewModel))
            if let player = AudioManager.shared.musicPlayers[String(describing: viewModel)] {
                viewModel.initialisePlayer(player: player)
            }
            viewModel.achievementManager = achievementManager

            let openedPropertyUpdater = achievementManager
                .getPropertyUpdater(for: TotalBeatmapDesignerOpenedProperty.self)
            openedPropertyUpdater.increment()
        }
        .onDisappear {
            AudioManager.shared.stopMusic(from: String(describing: viewModel))
        }
        .environmentObject(viewModel)
    }

    @ViewBuilder
    private func renderStartButton() -> some View {
        Button(action: {
            path.append(Page.playPage)
            gameViewModel.selectedGameMode = ModeFactory.defaultMode
            gameViewModel.initEngine(with: viewModel.beatmap)
        }) {
            Text("Start")
                .foregroundColor(.white)
                .font(.title2)
        }
    }

    @ViewBuilder
    private func renderSaveButton() -> some View {
        Button(action: {
            beatmapManager.saveBeatmap(namedBeatmap: viewModel.namedBeatmap)
        }) {
            Text("Save")
                .foregroundColor(.white)
                .font(.title2)
        }
    }
}
