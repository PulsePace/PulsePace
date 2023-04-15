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
    let songData: SongData
//    let bpm: Double
//    let offset: Double
    let preSpawnInterval: Double
    let sliderSpeed: Double
    var hitObjects: [any HitObject]
    var endBeat: Double {
        hitObjects.reduce(0, { x, y in
            max(x, y.endTime)
        })
    }

    init(
        songData: SongData,
        hitObjects: [any HitObject],
        preSpawnInterval: Double = 2,
        sliderSpeed: Double = 100
    ) {
        self.songData = songData
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
        return SerializedBeatmap(
            songData: songData.serialize(),
            preSpawnInterval: preSpawnInterval,
            sliderSpeed: sliderSpeed,
            stringifiedHOs: stringifiedHOs
        )
    }
}

struct SerializedBeatmap: Deserializable {
    typealias DeserialType = Beatmap
    let songData: SerializedSongData
    let preSpawnInterval: Double
    let sliderSpeed: Double
    // cannot put any SerializedHO here
    var stringifiedHOs: [HOLabelAndData]

    func deserialize() -> Beatmap {
        let deserializedHOs = stringifiedHOs.map { stringifiedHO in
            HOTypeFactory.assemble(hOTypeLabel: stringifiedHO.typeLabel, data: stringifiedHO.data).deserialize()
        }
        return Beatmap(
            songData: songData.deserialize(),
            hitObjects: deserializedHOs,
            sliderSpeed: sliderSpeed
        )
    }
}
