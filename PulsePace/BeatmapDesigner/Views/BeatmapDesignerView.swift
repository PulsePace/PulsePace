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
    @EnvironmentObject var propertyStorage: PropertyStorage
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var viewModel: BeatmapDesignerViewModel
    @EnvironmentObject var beatmapManager: BeatmapManager
    @EnvironmentObject var pageList: PageList
    @State private var isSavingAs = false

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
            .popup(isPresented: $isSavingAs) { SaveAsView(isSavingAs: $isSavingAs)
            } customize: { $0
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
            viewModel.eventManager = EventManager()
            viewModel.createDisplayLink()

            if let eventManager = viewModel.eventManager {
                propertyStorage.registerEventHandlers(eventManager: eventManager)
                eventManager.add(event: OpenBeatmapDesignerEvent(timestamp: Date().timeIntervalSince1970))
            }
        }
        .onDisappear {
            audioManager.stopPlayer()
            viewModel.invalidateDisplayLink()
            viewModel.sliderValue = 0
            viewModel.eventManager = nil
        }
    }

    @ViewBuilder
    private func renderStartButton() -> some View {
        Button(action: {
            gameViewModel.songData = viewModel.songData
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
            isSavingAs.toggle()
        }) {
            Text("Save")
                .foregroundColor(.white)
                .font(.title2)
        }
    }
}

struct OpenBeatmapDesignerEvent: Event {
    var timestamp: Double
}

struct PlaceHitObjectEvent: Event {
    var timestamp: Double
}

struct SaveAsView: View {
    @EnvironmentObject var beatmapManager: BeatmapManager
    @EnvironmentObject var viewModel: BeatmapDesignerViewModel
    @Binding var isSavingAs: Bool
    @State private var mapTitle = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Beatmap Name", text: $mapTitle)
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: 0xD3D3D3), lineWidth: 2)
                )
                .frame(width: 250)
                .foregroundColor(.white)
                .onAppear { print("Save as popup appeared") }

            Button(action: {
                if !mapTitle.isEmpty {
                    viewModel.mapTitle = mapTitle
                    isSavingAs.toggle()
                    Task {
                        await beatmapManager.saveBeatmap(namedBeatmap: viewModel.namedBeatmap)
                    }
                }
            }) {
                Text("Confirm")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.orange)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
        .background(Color(hex: 0x008081))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
