//
//  SongManager.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/12.
//

import Foundation

final class SongManager: ObservableObject {
    @Published private(set) var tracks: [SongData]

    init() {
        tracks = [
            SongData(track: "track_1", bpm: 123.482, offset: 0),
            SongData(track: "track_2", bpm: 116.040, offset: 0),
            SongData(track: "track_3", bpm: 122.883, offset: 0)
        ]
    }
}
