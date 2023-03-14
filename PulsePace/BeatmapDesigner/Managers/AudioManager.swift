//
//  AudioManager.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import Foundation
import AVKit

final class AudioManager: ObservableObject {
    @Published var player: AVAudioPlayer?

    func startPlayer(track: String) {
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("Resource not found: \(track)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Failed to initialise player", error)
        }
    }

    func stopPlayer() {
        guard let player = player else {
            return
        }
        player.stop()
    }

    func togglePlayer() {
        guard let player = player else {
            return
        }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
}
