//
//  BeatmapDesignerViewModel.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/13.
//

import Foundation
import SwiftUI

class BeatmapDesignerViewModel: ObservableObject {
    @Published var sliderValue: Double = 0
    @Published var hitObjects: PriorityQueue<any HitObject>
    @Published var isEditing = false
    @Published var bpm: Double = 123.482 // TODO: parameterise + add divider
    @Published var offset: Double = 0
    @Published var zoom: Double = 128
    @Published var divisorIndex: Double = 0
    let divisorList: [Double] = [3, 4, 6, 8, 12, 16]
    let audioManager = AudioManager()
    private var displayLink: CADisplayLink?

    var divisor: Double {
        divisorList[Int(divisorIndex)]
    }

    var bps: Double {
        bpm / 60
    }

    init() {
        hitObjects = PriorityQueue(sortBy: Self.hitObjectPriority )
        createDisplayLink()
    }

    private func createDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .default)
    }

    @objc func step(displaylink: CADisplayLink) {
        guard let player = audioManager.player, !isEditing else {
            return
        }
//        print(offset)
//        print(sliderValue)
        sliderValue = player.currentTime
    }

    static func hitObjectPriority(_ firstHitObject: any HitObject, _ secondHitObject: any HitObject) -> Bool {
        firstHitObject.beat < secondHitObject.beat
    }
}
