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
    @Binding var modeName: String

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.gameModes, id: \.title) { gameMode in
                    CardView(path: $path, modeName: $modeName, cardDisplayable: gameMode)
                }
            }
        }
        .padding(20)
    }
}
