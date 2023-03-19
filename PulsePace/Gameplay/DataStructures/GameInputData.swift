//
//  GameInputData.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 17/3/23.
//

import CoreGraphics

struct GameInputData {
    var location: CGPoint
    var songPositionReceived: Double

    init(location: CGPoint, songPositionReceived: Double) {
        self.location = location
        self.songPositionReceived = songPositionReceived
    }
}
