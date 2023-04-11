//
//  GameView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    // FIXME: Remove loc
    @EnvironmentObject var beatmapManager: BeatmapManager

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
            AudioManager.shared.playMusic(track: "test")
            if viewModel.gameEngine == nil {
                viewModel.initEngine(with: beatmapManager.beatmapChoices[1].beatmap)
            }
            viewModel.startGameplay()
            if let audioPlayer = AudioManager.shared.musicPlayer {
                viewModel.initialisePlayer(audioPlayer: audioPlayer)
            }
        }
        .onDisappear {
            AudioManager.shared.stopMusic()
            viewModel.stopGameplay()
        }
        .environmentObject(viewModel)
       .fullBackground(imageName: viewModel.gameBackground)
    }
}

// class GameViewFactory {
//    static func createGameView(for gameMode: String) -> some View {
//        let gameViewElements = ModeFactory.getModeAttachment(gameMode).gameViewElements
//        let view = ZStack {
//            ForEach(gameViewElements, id: \.self) { element in
//                GameViewElement.gameViewElementsBuilderMap[element]?()
//            }
//        }
//        return view
//    }
// }

enum GameViewElement {
    case playbackControls
    case gameplayArea
    case disruptorOptions
    case scoreBoard
    case leaderboard
    case matchFeed
    case livesCount

//    static let gameViewElementsBuilderMap: [GameViewElement: () -> AnyView] = [
//        .playbackControls: { GameControlView().eraseToAnyView() },
//        .gameplayArea: { GameplayAreaView().eraseToAnyView() },
//        .scoreBoard: { ScoreView().eraseToAnyView() }
//    ]
}

// extension View {
//    func eraseToAnyView() -> AnyView {
//        AnyView(self)
//    }
// }
