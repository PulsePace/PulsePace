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
    @Published var hitObjects: PriorityQueue<any HitObject>
    @Published var isEditing = false
    @Published var bpm: Double = 123.482 // TODO: parameterise
    @Published var offset: Double = 0
    @Published var zoom: Double = 128
    @Published var divisorIndex: Double = 0
    @Published var playbackRateIndex: Double = 3
    @Published var previewHitObject: (any HitObject)?
    let playbackRateList: [Double] = [0.25, 0.5, 0.75, 1]
    let divisorList: [Double] = [3, 4, 6, 8, 12, 16]
    private var player: AVAudioPlayer?
    private var displayLink: CADisplayLink?
    
    let editModeModifierList: [any EditModeModifier] = [TapEditModeModifier(), HoldEditModeModifier()]

    var divisor: Double {
        divisorList[Int(divisorIndex)]
    }

    var bps: Double {
        bpm / 60
    }

    init() {
        hitObjects = PriorityQueue(sortBy: Self.hitObjectPriority)
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
        zoom = min(1_024, zoom * 2) // TODO: constants
    }

    func decreaseZoom() {
        zoom = max(64, zoom / 2)
    }

    func registerPreviewHitObject() {
        guard let hitObject = previewHitObject else {
            return
        }
        hitObjects.enqueue(hitObject)
        previewHitObject = nil
    }

    static func hitObjectPriority(_ firstHitObject: any HitObject, _ secondHitObject: any HitObject) -> Bool {
        firstHitObject.beat < secondHitObject.beat
    }
}
