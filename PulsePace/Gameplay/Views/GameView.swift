//
//  GameView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var beatmapManager: BeatmapManager
    @Binding var path: [Page]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                GameplayAreaView()
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
            .popup(isPresented: $viewModel.gameEnded) {
                GameEndView(path: $path)
            }
            .navigationBarBackButtonHidden(viewModel.match != nil)
            .onChange(of: geometry.size, perform: { size in
                viewModel.initialiseFrame(size: size)
            })
        }
    }

    func startGame() {
        if viewModel.gameEngine == nil {
            viewModel.initEngine(with: beatmapManager.beatmapChoices[4].beatmap)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            audioManager.startPlayer(track: "test_trim")
            viewModel.startGameplay()
            if let audioPlayer = audioManager.player {
                viewModel.initialisePlayer(audioPlayer: audioPlayer)
            }
        }
    }

    func stopGame() {
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
