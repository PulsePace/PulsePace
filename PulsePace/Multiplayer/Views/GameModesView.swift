//
//  GameModesView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 29/3/23.
//

import SwiftUI

struct GameModesView: View {
    @EnvironmentObject var pageList: PageList
    @StateObject var viewModel = GameModesViewModel()
    @State var isHowToPlayShown = false

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .center) {
            Text("Select Game Mode")
                .font(Fonts.title)
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.gameModes, id: \.title) { gameMode in
                        CardView(cardDisplayable: gameMode)
                    }
                }
                .padding(20)
            }
        }
        .overlay(alignment: .topTrailing) {
            VStack {
                SystemIconButtonView(systemName: "info", action: { isHowToPlayShown = true })
                Text("How to Play")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(20)
        }
        .popup(isPresented: $isHowToPlayShown) {
            howToPlay
        } customize: { $0
        }
    }

    var howToPlay: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("How to Play")
                .font(Fonts.title2)
            classicModeInstructions
            infiniteModeInstructions
            coopModeInstructions
            competitiveModeInstructions
            Button(action: { isHowToPlayShown = false }) {
                Text("BACK")
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
        }
        .frame(maxWidth: 800)
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
            Text("There are 3 kinds of hit objects: tap, slide and hold. ") +
            Text("Start interacting with the hit objects when the hint " +
                 "circle closes and is the same size as the hit object " +
                 "to get the perfect score!")
        }
    }

    var infiniteModeInstructions: some View {
        VStack {
            Text("Infinite Mode")
                .font(Fonts.caption)
            Text("Play until you lose all lives.") +
            Text("Speed will get faster if you hit 5 objects in a row, and will get slower if you lose a life." +
                 "(Speed will not go beyond x2 or below x1.)" +
                 "Try to get as high a score as you can before you lose all 3 lives!")
        }
    }

    var coopModeInstructions: some View {
        VStack {
            Text("Catch the Potato")
                .font(Fonts.caption)
            Text("If your partner misses a hit object, it will spawn on " +
                 "your screen so that you have a chance to make up for it " +
                 "while your partner makes up for you. ") +
            Text("Your final score is " +
                 "a sum of both your individual scores!")
        }
    }

    var competitiveModeInstructions: some View {
        VStack {
            Text("Rhythm Battle")
                .font(Fonts.caption)
            Text("Play with up to 4 players! ") +
            Text("If you hit 5 hit objects in a row, a disruptor will be " +
                 "auto-spawned for one of your competitors. ") +
            Text("To select who gets the disruptor " +
                 "and what type it is (bomb or no hints), use the selection bar on the " +
                 "bottom of the screen. ") +
            Text("Watch the feed on top for match updates. ") +
            Text("Hit a bomb and you lose a life. Hit 3 bombs and you die. The " +
                 "player with the highest score in the end wins!")
        }
    }
}
