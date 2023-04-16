//
//  CardView.swift
//  PulsePace
//
//  Referenced from: https://www.appcoda.com/swiftui-card-view/
//  Created by Charisma Kausar on 29/3/23.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var pageList: PageList
    @EnvironmentObject var beatmapManager: BeatmapManager
    @EnvironmentObject var gameVM: GameViewModel

    var cardDisplayable: CardDisplayable

    var body: some View {
        Button(action: {
            gameVM.selectedGameMode = ModeFactory.getModeAttachment(cardDisplayable.metaInfo)
            if cardDisplayable.category == "Singleplayer" {
                beatmapManager.isPreloadedOnly = false
            } else {
                beatmapManager.isPreloadedOnly = true
            }

            pageList.navigate(to: cardDisplayable.page)
        }) {
            VStack {
                Image(cardDisplayable.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                HStack {
                    VStack(alignment: .leading) {
                        Text(cardDisplayable.category)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                        Text(cardDisplayable.title)
                            .font(Fonts.caption)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        Text(cardDisplayable.caption)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .layoutPriority(100)

                    Spacer()
                }
                .padding()
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}
