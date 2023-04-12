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
    var musicPlayers: [String: AVAudioPlayerNode] = [:]
    private var soundEffectPlayers: [String: AVAudioPlayerNode] = [:]

    var musicDuration: Double = 0
    private var musicFile = AVAudioFile()
    let playbackRateControl = AVAudioUnitVarispeed()

    func playMusic(track: String, from screen: String) {
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
        musicDuration = Double(audioFrameCount) / musicFile.fileFormat.sampleRate
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount) else {
            return
        }
        try? audioFile.read(into: buffer)
        let player = AVAudioPlayerNode()
        audioEngine.attach(player)
        audioEngine.attach(playbackRateControl)
        audioEngine.connect(player, to: playbackRateControl, format: nil)
        audioEngine.connect(playbackRateControl, to: audioEngine.mainMixerNode, format: nil)
        try? audioEngine.start()

        stopMusic(from: screen)
        musicPlayers[screen] = player
        audioEngine.connect(player, to: playbackRateControl, format: nil)
        audioEngine.connect(playbackRateControl, to: audioEngine.mainMixerNode, format: buffer.format)
        player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        player.play()
    }

    func seekMusic(to position: Double, from screen: String) {
        guard let player = musicPlayers[screen] else {
            return
        }
        let sampleRate = player.outputFormat(forBus: 0).sampleRate
        let newSampleTime = AVAudioFramePosition(sampleRate * Double(position))
        let length = UInt32(musicDuration - position)
        let frames = AVAudioFrameCount(UInt32(sampleRate) * length)
        player.stop()
        if frames > 1_000 {
            player.scheduleSegment(musicFile, startingFrame: newSampleTime,
                                   frameCount: frames, at: nil,
                                   completionHandler: nil)

        }
        player.play()

//        let sampleRate = musicFile.fileFormat.sampleRate
//        let framePosition = AVAudioFramePosition(position * sampleRate)
//        let audioTime = AVAudioTime(sampleTime: framePosition, atRate: sampleRate)
//        player.stop()
//        player.play(at: audioTime)
    }

    func stopMusic(from screen: String) {
        if let player = musicPlayers[screen] {
            player.stop()
            audioEngine.disconnectNodeOutput(player)
            musicPlayers[screen] = nil
        }
    }

    func increasePlaybackRate(from screen: String) {
        playbackRateControl.rate = min(1, playbackRateControl.rate + 0.25)
    }

    func decreasePlaybackRate(from screen: String) {
        playbackRateControl.rate = max(0.25, playbackRateControl.rate - 0.25)
    }

    func toggleMusic(from screen: String) {
        guard let player = musicPlayers[screen] else {
            return
        }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }

    func currentTime(from screen: String) -> TimeInterval {
        guard let player = musicPlayers[screen],
            let nodeTime: AVAudioTime = player.lastRenderTime,
            let playerTime: AVAudioTime = player.playerTime(forNodeTime: nodeTime)
        else {
            return 0
        }
        let sampleRate = Double(playerTime.sampleRate)
        let frameCount = Double(playerTime.sampleTime)
        let currentTime = frameCount / sampleRate
        return currentTime
    }
}
