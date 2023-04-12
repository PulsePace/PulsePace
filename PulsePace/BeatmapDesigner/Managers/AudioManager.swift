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
        guard let url = Bundle.main.url(forResource: track, withExtension: "m4a") else {
            print("Resource not found: \(track)")
            return
        }

        do {
            stopPlayer()
            player = try AVAudioPlayer(contentsOf: url)
            initialisePlayer(player: player)
        } catch {
            print("Failed to initialise player", error)
        }
    }

    func startPlayer(data: Data) {
        do {
            stopPlayer()
            player = try AVAudioPlayer(data: data)
            initialisePlayer(player: player)
        } catch {
            print("Failed to initialise player", error)
        }
    }

    func increasePlaybackRate() {
        guard let player = player else {
            return
        }
        player.rate = min(2, player.rate + 0.25)
    }

    func decreasePlaybackRate() {
        guard let player = player else {
            return
        }
        player.rate = max(0.25, player.rate - 0.25)
    }

    func setPlaybackRate(_ rate: Double) {
        guard let player = player else {
            return
        }
        player.rate = Float(Math.clamp(num: rate, minimum: 0.25, maximum: 2))
    }

    private func initialisePlayer(player: AVAudioPlayer?) {
        guard let player = player else {
            return
        }
        player.enableRate = true
        player.prepareToPlay()
        player.rate = 1
        player.numberOfLoops = -1
        player.play()
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
