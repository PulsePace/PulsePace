//
//  BeatmapDesignerViewModel.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/13.
//

import Foundation
import SwiftUI
import AVKit

class BeatmapDesignerViewModel: ObservableObject {
    @Published var sliderValue: Double = 0
    @Published var hitObjects: [any HitObject] = []
    @Published var isEditing = false
    @Published var bpm: Double = 123.482 // TODO: parameterise + add divider
    @Published var offset: Double = 0
    @Published var zoom: Double = 128
    @Published var divisorIndex: Double = 0
    @Published var playbackRateIndex: Double = 3
    let playbackRateList: [Double] = [0.25, 0.5, 0.75, 1]
    let divisorList: [Double] = [3, 4, 6, 8, 12, 16]
    private var player: AVAudioPlayer?
    private var displayLink: CADisplayLink?

    var divisor: Double {
        divisorList[Int(divisorIndex)]
    }

    var bps: Double {
        bpm / 60
    }

    init() {
        createDisplayLink()
    }

    private func createDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .default)
    }

    @objc func step(displaylink: CADisplayLink) {
        guard let player = player, !isEditing else {
            return
        }
        sliderValue = player.currentTime
    }

    func initialisePlayer(player: AVAudioPlayer) {
        self.player = player
    }

    func increaseZoom() {
        zoom = min(1_024, zoom * 2)
    }

    func decreaseZoom() {
        zoom = max(64, zoom / 2)
    }
}
