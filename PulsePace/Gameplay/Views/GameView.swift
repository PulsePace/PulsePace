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
        ZStack(alignment: .top) {
            GameplayAreaView()
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
                    .ignoresSafeArea()
            }
            .overlay(alignment: .topLeading) {
                LivesCountView()
            }
//            .overlay(alignment: .bottomTrailing) {
//                GameControlView()
//            }
            .overlay(alignment: .bottom) {
                VStack(alignment: .leading) {
                    HitStatusView()
                    DisruptorOptionsView()
                    GameControlView()
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .onAppear {
            audioManager.startPlayer(track: "test")
            if viewModel.gameEngine == nil {
                viewModel.initEngine(with: beatmapManager.beatmapChoices[1].beatmap)
            }
            viewModel.startGameplay()
            if let audioPlayer = audioManager.player {
                viewModel.initialisePlayer(audioPlayer: audioPlayer)
            }
        }
        .onDisappear {
            audioManager.stopPlayer()
            viewModel.exitGameplay()
        }
        .fullBackground(imageName: viewModel.gameBackground)
        .popup(isPresented: $viewModel.gameEnded) {
            GameEndView(path: $path)
        }
        .navigationBarBackButtonHidden(viewModel.match != nil)
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
