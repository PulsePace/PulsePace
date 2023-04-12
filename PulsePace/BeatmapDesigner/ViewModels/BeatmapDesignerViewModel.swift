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
    @Published var zoom: Double = 128
    @Published var divisorIndex: Double = 0
    @Published var playbackRateIndex: Double = 3
    @Published var previewHitObject: (any HitObject)?
    @Published var gestureHandler: any GestureHandler
//    @Published var isShowing = true
    var songData: SongData?
    var achievementManager: AchievementManager?
    let playbackRateList: [Double] = [0.25, 0.5, 0.75, 1]
    let divisorList: [Double] = [3, 4, 6, 8, 12, 16]
    var frame: CGSize = .zero
    private var player: AVAudioPlayer?
    private var displayLink: CADisplayLink?

    var gestureHandlerList: [any GestureHandler] = []

    var gridHeight: CGFloat {
        frame.height * 0.95
    }

    var gridWidth: CGFloat {
        gridSpacing * 16
    }

    var gridSpacing: CGFloat {
        gridHeight / 12
    }

    var gridOffset: CGSize {
        CGSize(width: (frame.width - gridSpacing * 16) / 2, height: frame.height * 0.05 / 2)
    }

    var divisor: Double {
        divisorList[Int(divisorIndex)]
    }

    var mainBeatSpacing: Double {
        zoom / bps
    }

    var subBeatSpacing: Double {
        mainBeatSpacing / divisor
    }

    var bpm: Double {
        songData?.bpm ?? 0
    }

    var offset: Double {
        songData?.offset ?? 0
    }

    var bps: Double {
        bpm / 60
    }

    var interval: Double {
        1 / (bps * divisor)
    }

    var quantisedBeat: Double {
        ((sliderValue - offset) / interval).rounded()
    }

    var quantisedTime: Double {
        interval * quantisedBeat
    }

    var songTitle: String {
        get async {
            await songData?.title ?? ""
        }
    }

    var namedBeatmap: NamedBeatmap {
        get async {
            NamedBeatmap(songTitle: await songTitle, beatmap: beatmap)
        }
    }

    var beatmap: Beatmap {
        // TODO: Assumes beatmap retrieved only once
        var hitObjectS2B: [any HitObject] = []
        let spb = 60 / bpm
        hitObjects.toArray().forEach { hitObject in

            if hitObject is TapHitObject {
                hitObjectS2B.append(TapHitObject(position: hitObject.position, startTime: hitObject.startTime / spb))
            } else if hitObject is HoldHitObject {
                hitObjectS2B.append(HoldHitObject(
                    position: hitObject.position,
                    startTime: hitObject.startTime / spb,
                    endTime: hitObject.endTime / spb)
                )
            } else if let slideHitObject = hitObject as? SlideHitObject {
                hitObjectS2B.append(SlideHitObject(
                    position: hitObject.position,
                    startTime: hitObject.startTime / spb,
                    endTime: hitObject.endTime / spb,
                    vertices: slideHitObject.vertices)
                )
            }
        }
        return Beatmap(bpm: bpm, offset: offset, hitObjects: hitObjectS2B)
    }

    init() {
        hitObjects = PriorityQueue(sortBy: Self.hitObjectPriority)
        gestureHandler = TapGestureHandler()
        gestureHandlerList = [
            TapGestureHandler(),
            HoldGestureHandler(),
            SlideGestureHandler()
        ]
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

//    func initialiseConfig() {
//        isShowing = true
//    }

    func virtualisePosition(_ position: CGPoint) -> CGPoint {
        let virtualXOffset = (position.x - gridOffset.width) * 40 / gridSpacing
        let virtualYOffset = (position.y - gridOffset.height) * 40 / gridSpacing
        return CGPoint(x: virtualXOffset, y: virtualYOffset)
    }

    func initialisePlayer(player: AVAudioPlayer) {
        self.player = player
    }

    func initialiseFrame(size: CGSize) {
        frame = size
    }

    func increaseZoom() {
        zoom = min(1_024, zoom * 2) // TODO: constants
    }

    func decreaseZoom() {
        zoom = max(64, zoom / 2)
    }

    func resetPreviewHitObject() {
        previewHitObject = nil
    }

    func holdPreviewHitObject(hitObject: any HitObject) {
        previewHitObject = hitObject
    }

    func isValidPosition(_ position: CGPoint) -> Bool {
        let virtualPosition = virtualisePosition(position)
        let isWithinHorizontally = virtualPosition.x >= 0 && virtualPosition.x <= 640
        let isWithinVertically = virtualPosition.y >= 0 && virtualPosition.y <= 480
        return isWithinHorizontally && isWithinVertically
    }

    func registerPreviewHitObject() {
        guard let hitObject = previewHitObject else {
            return
        }
        hitObjects.enqueue(hitObject)
        previewHitObject = nil
        incrementHitObjectsProperty()
    }

    private func incrementHitObjectsProperty() {
        if let objectsPlacedUpdater = achievementManager?
            .getPropertyUpdater(for: TotalHitObjectsPlacedProperty.self) {
            objectsPlacedUpdater.increment()
        }
    }

    static func hitObjectPriority(_ firstHitObject: any HitObject, _ secondHitObject: any HitObject) -> Bool {
        firstHitObject.startTime < secondHitObject.startTime
    }
}
