//
//  GameView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import SwiftUI
import PopupView

struct GameView: View {
    @EnvironmentObject var propertyStorage: PropertyStorage
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var viewModel: GameViewModel
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var beatmapManager: BeatmapManager
    @EnvironmentObject var pageList: PageList

    var body: some View {
        GeometryReader { geometry in
            renderGameplayAreaView(geometry: geometry)
            .popup(isPresented: $viewModel.gameEnded) {
                GameEndView()
            } customize: {
                $0
                    .type(.default)
                    .animation(.spring())
                    .dragToDismiss(false)
            }
        }
    }

    @ViewBuilder
    private func renderGameplayAreaView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .center) {
            GameplayAreaView()
                .disabled($viewModel.gameEnded.wrappedValue)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .modifier(GameViewTopOverlaysModifier())
        .modifier(GameViewBottomOverlaysModifier())
        .onAppear {
            startGame()
        }
        .onDisappear {
            stopGame()
        }
        .fullBackground(imageName: viewModel.gameBackground)
        .navigationBarBackButtonHidden(viewModel.match != nil)
        .onChange(of: geometry.size, perform: { size in
            viewModel.initialiseFrame(size: size)
        })
        .onChange(of: viewModel.playbackRate) { _ in
            audioManager.setPlaybackRate(viewModel.playbackRate)
        }
    }

    private func startGame() {
        if viewModel.gameEngine == nil {
            if viewModel.gameEngine == nil {
                if let selectedBeatmap = beatmapManager.selectedBeatmap {
                    viewModel.initEngine(with: selectedBeatmap)
                } else if let defaultBeatmapChoice = beatmapManager.defaultBeatmapChoice {
                    viewModel.initEngine(with: defaultBeatmapChoice.beatmap)
                }
                propertyStorage.registerEventHandlers(eventManager: gameEngine.eventManager)
                gameEngine.achievementManager = achievementManager
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let track = beatmapManager.selectedBeatmap?.songData.track {
                    audioManager.startPlayer(track: track)
                } else {
                    audioManager.startPlayer(track: "track_1")
                }
                viewModel.startGameplay()
                if let audioPlayer = audioManager.player {
                    viewModel.initialisePlayer(audioPlayer: audioPlayer)
                }
                audioManager.player?.play()
            }
        }
    }

    private func stopGame() {
        audioManager.stopPlayer()
        viewModel.exitGameplay()
        viewModel.songPosition = 0
    }
}

enum GameViewElement {
    case playbackControls
    case gameplayArea
    case disruptorOptions
    case scoreBoard
    case leaderboard
    case matchFeed
    case livesCount
}

struct GameViewTopOverlaysModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .overlay(alignment: .topTrailing) {
            ScoreView()
                .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            LeaderboardView()
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            MatchFeedView()
        }
        .overlay(alignment: .topLeading) {
            LivesCountView()
        }
    }
}

struct GameViewBottomOverlaysModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading) {
                HitStatusView()
                DisruptorOptionsView()
                GameControlView()
            }
        }
    }
}
