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
    let offset: Double
    let preSpawnInterval: Double = 0.5
    let sliderSpeed: Double = 50
    var hitObjects: [any HitObject]
}
