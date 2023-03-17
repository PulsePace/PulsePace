//
//  Beatmap.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/17.
//

import Foundation

struct Beatmap {
    /// All the "time units" are in beats
    let bpm: Double
    let offset: Double = 0.0
    let preSpawnInterval: Double
    let sliderSpeed: Double
    var hitObjects: [any HitObject]
}
