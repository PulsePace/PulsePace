//
//  CardView.swift
//  PulsePace
//
//  Referenced from: https://www.appcoda.com/swiftui-card-view/
//  Created by Charisma Kausar on 29/3/23.
//

import SwiftUI

struct CardView: View {
    @Binding var path: [Page]
    @Binding var modeName: String

    var cardDisplayable: CardDisplayable

    var body: some View {
        Button(action: {
            modeName = cardDisplayable.metaInfo
            path.append(cardDisplayable.page)
        }) {
            VStack {
                Image(cardDisplayable.image) // TODO: Add image assets
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                HStack {
                    VStack(alignment: .leading) {
                        Text(cardDisplayable.category)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(cardDisplayable.title)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                        Text(cardDisplayable.caption)
                            .font(.caption)
                            .foregroundColor(.secondary)
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
