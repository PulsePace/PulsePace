//
//  Conductor.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 15/3/23.
//

class Conductor {
    var songPosition: Double
    var bpm: Double
    var currBeat: Double {
        songPosition * bpm
    }

    init(songPosition: Double, bpm: Double) {
        self.songPosition = songPosition
        self.bpm = bpm
    }
}
