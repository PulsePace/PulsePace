//
//  SongSelectView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/12.
//

import SwiftUI

struct SongSelectView: View {
    // TODO: environment object for song manager
    @StateObject var viewModel = SongSelectViewModel(songManager: SongManager())

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.tracks, id: \.track) { data in
                    SongCardView(songData: data)
                }
            }
            .padding(.init(top: 0, leading: 160, bottom: 0, trailing: 160))
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
        .navigationTitle("Select a song")
    }
}
