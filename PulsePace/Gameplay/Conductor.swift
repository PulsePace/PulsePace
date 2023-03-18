//
//  Conductor.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 15/3/23.
//

class Conductor {
    // song position in beats
    var songPosition: Double
    var bpm: Double
    var playbackScale: Double

    init(bpm: Double, playbackScale: Double = 1) {
        self.songPosition = 0
        self.playbackScale = playbackScale
        self.bpm = bpm
    }

    func step(_ deltaTime: Double) {
        songPosition += deltaTime / 60 * bpm * playbackScale
    }
}
