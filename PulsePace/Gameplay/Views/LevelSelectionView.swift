//
//  LevelSelectionView.swift
//  PulsePace
//
//  Created by James Chiu on 16/4/23.
//

import Foundation
import SwiftUI

struct LevelSelectionView: View {
    @EnvironmentObject var beatmapManager: BeatmapManager
    @EnvironmentObject var pageList: PageList

    var body: some View {
        ScrollView {
            renderSelections(adaptBeatmapTable())
        }
    }

    func adaptBeatmapTable() -> [[NamedBeatmap]] {
        var beatmapGroups: [[NamedBeatmap]] = []
        var allSongTitles = Set(beatmapManager.preloadedBeatmapChoices.keys)
        if !beatmapManager.isPreloadedOnly {
            allSongTitles = allSongTitles.union(beatmapManager.beatmapChoices.keys)
        }

        allSongTitles.forEach { songTitle in
            var beatmapGroup: [NamedBeatmap] = []
            if let preloadedGroup = beatmapManager.preloadedBeatmapChoices[songTitle]?.toArray() {
                beatmapGroup.append(contentsOf: preloadedGroup)
            }

            if !beatmapManager.isPreloadedOnly,
                let designedGroup = beatmapManager.beatmapChoices[songTitle]?.toArray() {
                beatmapGroup.append(contentsOf: designedGroup)
            }
            beatmapGroups.append(beatmapGroup)
        }
        return beatmapGroups
    }

    func renderSelections(_ beatmapGroups: [[NamedBeatmap]]) -> some View {
        VStack {
            ForEach(Array(beatmapGroups.enumerated()), id: \.offset) { beatmapGroup in
                VStack {
                    Text(beatmapGroup.element.first?.songTitle ?? "")
                        .font(Fonts.title2)

                    ForEach(Array(beatmapGroup.element.enumerated()), id: \.offset) { wrappedBeatmap in
                        let namedBeatmap = wrappedBeatmap.element
                        HStack {
                            Text(namedBeatmap.mapTitle)
                                .font(.title3)
                                .fontWeight(.medium)

                            Spacer()

                            Button(action: {
                                beatmapManager.selectedBeatmap = namedBeatmap.beatmap
                                pageList.navigate(to: .playPage)
                            }) {
                                Text("Go")
                                    .font(.headline)
                                    .padding(5)
                                    .padding(.horizontal, 15)
                                    .background(.purple)
                                    .cornerRadius(5)
                            }
                        }
                        .frame(width: 525)
                    }
                }
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
    }
}
