//
//  Conductor.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 15/3/23.
import Foundation

class Conductor: ModeSystem {
    // song position in beats
    var songPosition: Double
    var bpm: Double?
    var playbackScale: Double
    var songDuration: Double?
    var totalBeats: Double {
        (songDuration ?? 1) / 60 * (bpm ?? 1)
    }

    init(songPosition: Double = 0, playbackScale: Double = 1) {
        self.songPosition = songPosition
        self.playbackScale = playbackScale
    }

    init(bpm: Double, playbackScale: Double = 1) {
        self.songPosition = 0
        self.playbackScale = playbackScale
        self.bpm = bpm
    }

    func feedBeatmap(beatmap: Beatmap) {
        bpm = beatmap.songData.bpm
        songDuration = beatmap.songDuration
    }

    func step(deltaTime: Double, songPosition: Double) {
        guard let bpm = bpm else {
            fatalError("BPM must be initialised")
        }
        self.songPosition += deltaTime / 60 * bpm * playbackScale
    }

    func getNearestWholeBeat(offset: Double) -> Double {
        ceil(songPosition) + offset
    }

    func reset() {
        songPosition = 0
        playbackScale = 1
        bpm = nil
    }

    func registerEventHandlers(eventManager: EventManagable) {
    }
}
