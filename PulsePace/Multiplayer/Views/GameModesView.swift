//
//  GameModesView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 29/3/23.
//

import SwiftUI

struct GameModesView: View {
    @StateObject var viewModel = GameModesViewModel()
    @Binding var path: [Page]
    @State var isHowToPlayShown = false

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .center) {
            Text("Select Game Mode")
                .font(Fonts.title)
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.gameModes, id: \.title) { gameMode in
                        CardView(path: $path, cardDisplayable: gameMode)
                    }
                }
                .padding(20)
            }
        }
        .overlay(alignment: .topTrailing) {
            HStack {
                Text("How to Play")
                    .font(Fonts.caption)
                SystemIconButtonView(systemName: "info", action: { isHowToPlayShown = true })
                    .padding(20)
            }
        }
        .popup(isPresented: $isHowToPlayShown) {
            howToPlay
        }
    }

    var howToPlay: some View {
        VStack(alignment: .center) {
            classicModeInstructions
            coopModeInstructions
            competitiveModeInstructions
            Button(action: { isHowToPlayShown = false }) {
                Text("Back")
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 60)
        .padding(.vertical, 35)
        .background(.purple)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 4)
        )
        .shadow(radius: 10)
    }

    var classicModeInstructions: some View {
        VStack {
            Text("Classic Mode")
                .font(Fonts.caption)
            Text("There are 3 kinds of hit objects: tap, slide and hold. " +
                 "Start interacting with the hit objects when the hint " +
                 "circle closes and is the same size as the hit object " +
                 "to get the perfect score!")
        }
    }

    var coopModeInstructions: some View {
        VStack {
            Text("Catch the Potato")
                .font(Fonts.caption)
            Text("If your partner misses a hit object, it will spawn on " +
                 "your screen so that you have a chance to make up for it " +
                 "while your partner makes up for you. Your final score is " +
                 "a sum of both your individual scores!")
        }
    }

    var competitiveModeInstructions: some View {
        VStack {
            Text("Rhythm Battle")
                .font(Fonts.caption)
            Text("Play with up to 4 players to find the rhythm master! " +
                 "If you get an x5 combo, a disruptor will be auto-spawned " +
                 "on one of your competitor's beatmaps. To select who gets " +
                 "the disruptor and what type of disruptor it is (either " +
                 "bomb or no hints), use the selection bar on the bottom " +
                 "of the screen. Hit a bomb and you lose a life. Hit 3 " +
                 "bombs and you die. The player with the highest score in " +
                 "the end wins the match!")
        }
    }
}
