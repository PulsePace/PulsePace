//
//  SongCardView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/12.
//

import SwiftUI
import AVKit

struct SongCardView: View {
    let songData: SongData

    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel
    @EnvironmentObject var pageList: PageList
    @State private var title = "Unknown Title"
    @State private var artist = "Unknown Artist"
    @State private var thumbnail = Image(systemName: "music.note")

    var body: some View {
        Button(action: {
            beatmapDesigner.songData = songData
            pageList.navigate(to: .designPage)
        }) {
            HStack {
                thumbnail
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .padding(12)

                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(Font.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)

                    Text(artist)
                        .font(.subheadline)
                        .font(Font.system(size: 20, weight: .light))
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()
            }
            .frame(height: 120)
            .background(.white.opacity(0.2))
            .cornerRadius(12)
        }
        .task {
            title = await songData.title
            artist = await songData.artist
            if let uiImage = UIImage(data: await songData.thumbnailData) {
                thumbnail = Image(uiImage: uiImage)
            }
        }
    }
}
