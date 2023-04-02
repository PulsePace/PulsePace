//
//  Beatmap.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/17.
//

import Foundation

struct Beatmap {
    typealias SerialType = SerializedBeatmap
    /// All the "time units" are in beats
    let bpm: Double
    let offset: Double
    let preSpawnInterval: Double
    let sliderSpeed: Double
    var hitObjects: [any HitObject]

    init(bpm: Double, offset: Double,
         hitObjects: [any HitObject], preSpawnInterval: Double = 2,
         sliderSpeed: Double = 100) {
        self.bpm = bpm
        self.offset = offset
        self.hitObjects = hitObjects
        self.preSpawnInterval = preSpawnInterval
        self.sliderSpeed = sliderSpeed
    }
}

extension Beatmap: Serializable {
    func serialize() -> SerializedBeatmap {
        let encoder = JSONEncoder()
        let stringifiedHOs = hitObjects.map { hitObject in
            do {
                let serializedHO = hitObject.serialize()
                return HOLabelAndData(typeLabel: serializedHO.typeLabel,
                                      data: String(data: try encoder.encode(serializedHO), encoding: .utf8) ?? "")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return SerializedBeatmap(bpm: bpm, offset: offset,
                                 preSpawnInterval: preSpawnInterval, sliderSpeed: sliderSpeed,
                                 stringifiedHOs: stringifiedHOs)
    }
}

struct SerializedBeatmap: Deserializable {
    typealias DeserialType = Beatmap
    let bpm: Double
    let offset: Double
    let preSpawnInterval: Double
    let sliderSpeed: Double
    // cannot put any SerializedHO here
    var stringifiedHOs: [HOLabelAndData]

    func deserialize() -> Beatmap {
        let decoder = JSONDecoder()
        let deserializedHOs = stringifiedHOs.map { stringifiedHO in
            HOTypeFactory.assemble(hOTypeLabel: stringifiedHO.typeLabel, data: stringifiedHO.data).deserialize()
        }
        return Beatmap(bpm: bpm, offset: offset,
                       hitObjects: deserializedHOs,
                       preSpawnInterval: preSpawnInterval, sliderSpeed: sliderSpeed)
    }
}
