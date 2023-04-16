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
    @EnvironmentObject var pageList: PageList

    var body: some View {
        ZStack(alignment: .center) {
            GameplayAreaView()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
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
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading) {
                HitStatusView()
                DisruptorOptionsView()
                GameControlView()
            }
        }
        .onAppear {
            if viewModel.gameEngine == nil {
                viewModel.initEngine(with: beatmapManager.beatmapChoices[0].beatmap)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let track = viewModel.songData?.track {
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
        .onDisappear {
            audioManager.stopPlayer()
            viewModel.exitGameplay()
            viewModel.songPosition = 0
        }
        .fullBackground(imageName: viewModel.gameBackground)
        .popup(isPresented: $viewModel.gameEnded) {
            GameEndView()
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
