//
//  GameView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import SwiftUI

// TODO: Attach Gesture Modifiers to each rendered GameHO
struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @EnvironmentObject var audioManager: AudioManager

    init(viewModel: GameViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            GameplayAreaView()
            .overlay(alignment: .topTrailing) {
                ScoreView()
                    .ignoresSafeArea()
            }
            .overlay(alignment: .bottomTrailing) {
                GameControlView()
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .onAppear {
            audioManager.startPlayer(track: "test")
            viewModel.startGameplay()
        }
        .onDisappear {
            audioManager.stopPlayer()
            viewModel.stopGameplay()
        }
        .environmentObject(viewModel)
        .fullBackground(imageName: viewModel.gameBackground)
    }

    func renderSlideGameHO(slideGameHOVMs: [SlideGameHOVM]) -> some View {
        ZStack {
            ForEach(slideGameHOVMs) { slideGameHOVM in
                SlideGameHOView(slideGameHOVM: slideGameHOVM)
            }
        }
    }

    func renderHoldGameHO(holdGameHOVMs: [HoldGameHOVM]) -> some View {
        ZStack {
            ForEach(holdGameHOVMs) { holdGameHOVM in
                HoldGameHOView(holdGameHOVM: holdGameHOVM)
            }
        }
    }

    func renderTapGameHO(tapGameHOVMs: [TapGameHOVM]) -> some View {
        ZStack {
            ForEach(tapGameHOVMs) { tapGameHOVM in
               TapGameHOView(tapGameHOVM: tapGameHOVM)
            }
        }
    }
}

struct SlideGameHOView: View {
    let slideGameHOVM: SlideGameHOVM

    var body: some View {
        let slideGameHO = slideGameHOVM.gameHO
        let ringDiameter: CGFloat = min(800, max(100, 100 + 200 * slideGameHOVM.ringScale))

        return ZStack {
            DrawShapeBorder(points: [slideGameHO.position] + slideGameHO.vertices).stroked()

            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: ringDiameter, height: ringDiameter)
                .position(x: slideGameHO.position.x,
                          y: slideGameHO.position.y)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: slideGameHO.expectedPosition.x,
                          y: slideGameHO.expectedPosition.y)

            if let lastVertex = slideGameHO.vertices.last {
                Circle()
                    .fill(.white)
                    .frame(width: 100, height: 100)
                    .position(x: lastVertex.x,
                              y: lastVertex.y)
            }

            ForEach(slideGameHO.vertices, id: \.self) { position in
                Circle()
                    .fill(.white)
                    .frame(width: 20, height: 20)
                    .position(x: position.x,
                              y: position.y)
            }
        }
        .opacity(slideGameHOVM.opacity)
    }
}

struct HoldGameHOView: View {
    let holdGameHOVM: HoldGameHOVM

    var body: some View {
        let holdGameHO = holdGameHOVM.gameHO
        let ringDiameter: CGFloat = min(800, max(100, 100 + 200 * holdGameHOVM.ringScale))

        return ZStack {
            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: ringDiameter, height: ringDiameter)
                .position(x: holdGameHO.position.x,
                          y: holdGameHO.position.y)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: holdGameHO.position.x,
                          y: holdGameHO.position.y)
        }
        .opacity(holdGameHOVM.opacity)
    }
}

struct TapGameHOView: View {
    let tapGameHOVM: TapGameHOVM

    var body: some View {
        let tapGameHO = tapGameHOVM.gameHO
        let ringDiameter: CGFloat = min(800, max(100, 100 + 200 * tapGameHOVM.ringScale))

        return ZStack {
            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: ringDiameter, height: ringDiameter)
                .position(x: tapGameHO.position.x,
                          y: tapGameHO.position.y)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: tapGameHO.position.x,
                          y: tapGameHO.position.y)
        }
        .opacity(tapGameHOVM.opacity)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
