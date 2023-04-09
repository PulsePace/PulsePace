//
//  AudioManager.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import Foundation
import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    
    private let audioEngine = AVAudioEngine()
    private var musicPlayer: AVAudioPlayerNode?
    private var soundEffectPlayer: AVAudioPlayerNode?
    
    private var musicTracks: [String: AVAudioPlayerNode] = [:]

    func playMusic(track: String) {
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("Resource not found: \(track)")
            return
        }
        guard let player = createAudioPlayerNode(for: url) else {
            return
        }
        stopMusic()
        musicPlayer = player
        audioEngine.connect(player, to: audioEngine.mainMixerNode, format: nil)
        player.play()
    }
    
    func stopMusic() {
        musicPlayer?.stop()
        audioEngine.disconnectNodeOutput(musicPlayer!)
        musicPlayer = nil
    }

    func increasePlaybackRate() {
        guard let player = musicPlayer else {
            return
        }
        player.rate = min(1, player.rate + 0.25)
    }

    func decreasePlaybackRate() {
        guard let player = musicPlayer else {
            return
        }
        player.rate = max(0.25, player.rate - 0.25)
    }
    
    private func setPlaybackRate(to rate: Float) {
        if let player = musicPlayer {
            player.rate = rate
        }
    }

    func toggleMusic() {
        guard let player = musicPlayer else {
            return
        }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    private func createAudioPlayerNode(for url: URL) -> AVAudioPlayerNode? {
        guard let audioFile = try? AVAudioFile(forReading: url) else {
            return nil
        }
        let audioFormat = audioFile.processingFormat
        let audioFrameCount = UInt32(audioFile.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount) else {
            return nil
        }
        try? audioFile.read(into: buffer)
        let player = AVAudioPlayerNode()
        player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        audioEngine.attach(player)
        audioEngine.prepare()
        try? audioEngine.start()
        return player
    }
}
