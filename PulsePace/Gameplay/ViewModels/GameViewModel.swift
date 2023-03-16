//
//  GameViewModel.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

import Foundation
import QuartzCore
import AVKit

class GameViewModel: ObservableObject {
    private var songPlayer: AVAudioPlayer?
    private var displayLink: CADisplayLink?
//    private var gameEngine: GameEngine

    var score: String {
        String(format: "%06d", 71_143)
    }

    var accuracy: String {
        String(Double(round(100 * 82.3883) / 100)) + "%"
    }

    var combo: String {
        String(14) + "x"
    }

    var health: Double {
        50
    }

//    var hitObjects: PriorityQueue<any GameHO> {
//        PriorityQueue<any HitObject>()
//    }

    var gameBackground: String {
        ""
    }

    init() {
        createDisplayLink()
    }

    @objc func step(displaylink: CADisplayLink) {

    }

    func stopGameplay() {
        displayLink?.invalidate()
    }

    private func createDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .default)
    }

}
