//
//  SlideGameHO.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation
import simd

// Straight slider
class SlideGameHO: GameHO {
    typealias Vector2 = SIMD2<Double>
    var fromPartner = false

    let wrappingObject: Entity
    let position: CGPoint
    let vertices: [CGPoint]
    // Each waypoint is between 0 and 1
    let verticeBeatpoints: [Double]
    private var currEdgeIndex = 0

    let lifeStart: Double
    let optimalStart: Double
    let optimalStageStart: LifeStage
    let optimalLife: Double
    let optimalEnd: Double
    let optimalStageEnd: LifeStage
    let lifeEnd: Double
    // lifestage is clamped between 0 and 1, 0.5 being the optimal
    var lifeStage = LifeStage.startStage
    var onLifeEnd: [(SlideGameHO) -> Void] = []

    var expectedPosition: CGPoint
    private var reachedEnd = false

    let maxPositionError: Double = 20
    var minimumProximity: Double = 30
    var proximityScore: Double = 0
    var lastCheckedSongPosition: Double?
    var isHit = false

    init(slideHO: SlideHitObject, wrappingObject: Entity, preSpawnInterval: Double, slideSpeed: Double) {
        if slideHO.vertices.count < 1 {
            fatalError("Each slider hit object should at least have two vertices")
        }

        self.position = slideHO.position
        self.vertices = slideHO.vertices
        self.wrappingObject = wrappingObject

        self.lifeStart = slideHO.startTime - preSpawnInterval
        self.optimalStart = slideHO.startTime

        let waypointData = SlideGameHO.populateWaypoints(
            slideSpeed: slideSpeed,
            optimalStart: slideHO.startTime,
            position: slideHO.position,
            vertices: slideHO.vertices
        )
        self.optimalLife = waypointData.0
        self.verticeBeatpoints = waypointData.1
        self.optimalEnd = slideHO.startTime + optimalLife
        self.lifeEnd = slideHO.startTime + optimalLife + preSpawnInterval
        let normSpawnInterval = Lerper.linearFloat(
            from: 0,
            to: 1,
            t: preSpawnInterval / (waypointData.0 + preSpawnInterval * 2)
        )
        self.optimalStageStart = LifeStage(normSpawnInterval)
        self.optimalStageEnd = LifeStage(1 - normSpawnInterval)

        self.expectedPosition = slideHO.position
    }

    func updateState(currBeat: Double) {
        setExpectedPosition(currBeat: currBeat)

        lifeStage = LifeStage(Lerper.linearFloat(from: 0, to: 1, t: abs(currBeat - lifeStart) / lifeTime))
        if currBeat - lifeStart >= lifeTime {
            destroyObject()
        }
    }

    func checkOnInput(input: InputData) {
        guard let lastCheckedSongPosition = lastCheckedSongPosition else {
            lastCheckedSongPosition = input.timeReceived
            return
        }
        guard input.timeReceived != lastCheckedSongPosition else {
            return
        }

        let locationError = simd_length(SIMD2(
            x: input.location.x - self.expectedPosition.x,
            y: input.location.y - self.expectedPosition.y
        ))

        // if drag too far away
        if locationError > maxPositionError {
            // miss
            destroyObject()
            return
        }

        let clampedLocationError = Math.clamp(num: locationError,
                                              minimum: 0,
                                              maximum: minimumProximity) / minimumProximity
        let deltaTime = input.timeReceived - lastCheckedSongPosition
        proximityScore += (1 - clampedLocationError) * deltaTime / optimalLife
        self.lastCheckedSongPosition = input.timeReceived
    }

    func checkOnInputEnd(input: InputData) {
        // if drag ended too early
        if currEdgeIndex < vertices.count - 1 {
            // miss
//            destroyObject()
        }
        isHit = true
    }

    private func setExpectedPosition(currBeat: Double) {
        if reachedEnd {
            return
        }

        let startBeat = verticeBeatpoints[currEdgeIndex]
        let endTime = verticeBeatpoints[currEdgeIndex + 1]
        var edgeProgress = (currBeat - startBeat) / (endTime - startBeat)

        while edgeProgress >= 1 {
            edgeProgress -= 1
            currEdgeIndex += 1
        }

        if currEdgeIndex >= vertices.count {
            reachedEnd = true
            return
        }

        let startPoint = currEdgeIndex == 0 ? position : vertices[currEdgeIndex - 1]
        let endPoint = vertices[currEdgeIndex]

        expectedPosition = Lerper.linearVector2(from: startPoint, to: endPoint, t: edgeProgress)
    }

    private static func populateWaypoints(
        slideSpeed: Double,
        optimalStart: Double,
        position: CGPoint,
        vertices: [CGPoint]) -> (Double, [Double]
    ) {
        var currBeatpoint = optimalStart
        var lastVertice = position
        var verticeBeatpoints = [currBeatpoint]
        for vertice in vertices {
            let interval = simd_length(
                Vector2(
                    x: vertice.x - lastVertice.x,
                    y: vertice.y - lastVertice.y
                )
            ) / slideSpeed
            currBeatpoint += interval
            verticeBeatpoints.append(currBeatpoint)
            lastVertice = vertice
        }

        guard let lastBeatpoint = verticeBeatpoints.last else {
            fatalError("Slider must at least have two vertices")
        }

        return (lastBeatpoint - optimalStart, verticeBeatpoints)
    }
}
