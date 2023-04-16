//
//  SongSelectViewModel.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/12.
//

import Foundation
import SwiftUI

class SongSelectViewModel: ObservableObject {
    private let songManager: SongManager

    init(songManager: SongManager) {
        self.songManager = songManager
    }

    var tracks: [SongData] {
        songManager.tracks
    }
}
