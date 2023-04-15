//
//  HitObjectManager.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

class HitObjectManager: ModeSystem, EventSource {
    var eventManager: EventManagable?
    private var counter = 0
    private var remover: ((Entity) -> Void)?
    private var queuedHitObjects: MyQueue<any HitObject>
    var offset = 0.0
    private var slideSpeed = 0.0
    var preSpawnInterval = 0.0
    var songEndBeat = 0.0
    let songEndBuffer: Double
    private var lastHitObjectRemoved = false

    var gameHOTable: [Entity: any GameHO]
    private var allObjects: Set<Entity>
    lazy var objRemover = { [weak self] (eventManager: EventManagable) -> (Entity) -> Void in {
            guard let self = self else {
                fatalError("No active hit object system to remove entities")
            }
            self.allObjects.remove($0)
            guard let removedGameHO = self.gameHOTable.removeValue(forKey: $0) else {
                return
            }

            if !removedGameHO.isHit {
                eventManager.add(event: MissEvent(gameHO: removedGameHO, timestamp: Date().timeIntervalSince1970))
            }
        }
    }

    lazy var gameHOAdder: (any GameHO) -> Void = { [weak self] gameHO in
        self?.allObjects.insert(gameHO.wrappingObject)
        self?.gameHOTable[gameHO.wrappingObject] = gameHO
    }

    func reset() {
        queuedHitObjects.removeAll()
        offset = 0
        slideSpeed = 0
        preSpawnInterval = 0
        counter = 0
        songEndBeat = 0
        lastHitObjectRemoved = false
    }

    func registerEventHandlers(eventManager: EventManagable) {
        lazy var noHandler = { (_: EventManagable, _: NoEvent) -> Void in
            fatalError("No event should not be emitted")
        }
        eventManager.registerHandler(noHandler)
        self.eventManager = eventManager
    }

    init(_ songEndBuffer: Double = 5) {
        queuedHitObjects = MyQueue()
        self.songEndBuffer = songEndBuffer
        gameHOTable = [:]
        allObjects = Set()
    }

    func feedBeatmap(beatmap: Beatmap, eventManager: EventManagable) {
        self.remover = objRemover(eventManager)
        self.preSpawnInterval = beatmap.preSpawnInterval
        self.offset = beatmap.offset
        self.slideSpeed = beatmap.sliderSpeed
        self.songEndBeat = beatmap.endBeat
        beatmap.hitObjects.forEach { hitObject in queuedHitObjects.enqueue(hitObject) }
    }

    func step(deltaTime: Double, songPosition: Double) {
        let spawnGameHOs = checkBeatMap(songPosition)
        spawnGameHOs.forEach { gameHOAdder($0) }

        // Update state of gameHO
        allObjects.forEach { object in
            if let gameHO = gameHOTable[object] {
                gameHO.updateState(currBeat: songPosition)
            } else {
                print("By game design params, all objects should have a hit object component")
            }
        }
    }

    // Takes in a BeatMap
    func checkBeatMap(_ currBeat: Double) -> [any GameHO] {
        var gameHOSpawned: [any GameHO] = []
        while let firstInQueue = queuedHitObjects.peek() {
            if firstInQueue.startTime - preSpawnInterval + offset >= currBeat {
                return gameHOSpawned
            }

            gameHOSpawned.append(spawnGameHitObject(firstInQueue))
            _ = queuedHitObjects.dequeue()
        }

        if !lastHitObjectRemoved && currBeat >= songEndBeat + songEndBuffer {
            guard let eventManager = eventManager else {
                fatalError("No event manager attached")
            }
            // Conductor should be paused here to prevent step
            eventManager.add(event: LastHitobjectRemovedEvent(timestamp: Date().timeIntervalSince1970))
            lastHitObjectRemoved = true
        }

        return gameHOSpawned
    }

    func spawnGameHitObject(_ hitObject: any HitObject) -> any GameHO {
        guard let remover = remover else {
            fatalError("Hit object manager must have a valid remover")
        }

        let entity = Entity(id: counter, remover: remover)
        let newGameHO: any GameHO
        if let tapHO = hitObject as? TapHitObject {
            newGameHO = TapGameHO(tapHO: tapHO, wrappingObject: entity, preSpawnInterval: preSpawnInterval)
        } else if let slideHO = hitObject as? SlideHitObject {
            newGameHO = SlideGameHO(
                slideHO: slideHO,
                wrappingObject: entity,
                preSpawnInterval: preSpawnInterval,
                slideSpeed: slideSpeed
            )
        } else if let holdHO = hitObject as? HoldHitObject {
            newGameHO = HoldGameHO(
                holdHO: holdHO,
                wrappingObject: entity,
                preSpawnInterval: preSpawnInterval
            )
        } else {
            fatalError("Hit object type not found")
        }
        counter += 1
        return newGameHO
    }
}
