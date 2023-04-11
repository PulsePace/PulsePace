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
    var musicPlayer: AVAudioPlayerNode?
    private var soundEffectPlayers: [AVAudioPlayerNode] = []

    var musicDuration: Double = 0
    private var musicFile = AVAudioFile()

//    private var musicTracks: [String: AVAudioPlayerNode] = [:]

    func playMusic(track: String) {
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("Resource not found: \(track)")
            return
        }

        guard let audioFile = try? AVAudioFile(forReading: url) else {
            return
        }
        let audioFormat = audioFile.processingFormat
        let audioFrameCount = UInt32(audioFile.length)
        musicFile = audioFile
        musicDuration = Double(audioFrameCount)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount) else {
            return
        }
        try? audioFile.read(into: buffer)
        let player = AVAudioPlayerNode()
        audioEngine.attach(player)
        audioEngine.connect(player, to: audioEngine.mainMixerNode, format: nil)
        try? audioEngine.start()

        stopMusic()
        musicPlayer = player
        audioEngine.connect(player, to: audioEngine.mainMixerNode, format: buffer.format)
        player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        player.play()
    }

    func seekMusic(to position: Double) {
        let sampleRate = musicPlayer?.outputFormat(forBus: 0).sampleRate ?? 0
        let newSampleTime = AVAudioFramePosition(sampleRate * Double(position))
        let length = UInt32(musicDuration - position)
        let frames = AVAudioFrameCount(UInt32(sampleRate) * length)
        musicPlayer?.stop()
        if frames > 1_000 {
            musicPlayer?.scheduleSegment(musicFile, startingFrame: newSampleTime,
                                         frameCount: frames, at: nil,
                                         completionHandler: nil)
        }
        musicPlayer?.play()
    }

    func stopMusic() {
        if let player = musicPlayer {
            player.stop()
            audioEngine.disconnectNodeOutput(player)
            musicPlayer = nil
        }
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

    func currentTime() -> TimeInterval {
        if let nodeTime: AVAudioTime = musicPlayer?.lastRenderTime,
           let playerTime: AVAudioTime = musicPlayer?.playerTime(forNodeTime: nodeTime) {
           return Double(Double(playerTime.sampleTime) / playerTime.sampleRate)
        }
        return 0
    }
}
