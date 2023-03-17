//
//  Beatmap.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/17.
//

import Foundation

class Beatmap {
    let bpm: Double
    let offset: Double
    var hitObjects: [any HitObject]

    init(bpm: Double, offset: Double, hitObjects: [any HitObject]) {
        self.bpm = bpm
        self.offset = offset
        self.hitObjects = hitObjects
    }
}
