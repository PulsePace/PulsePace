//
//  HitEvent.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

struct HitEvent: Event {
    var timestamp: Double = 0.0
    var gameHO: any GameHO

    init(gameHO: any GameHO, timestamp: Double) {
        self.gameHO = gameHO
        self.timestamp = timestamp
    }
}
