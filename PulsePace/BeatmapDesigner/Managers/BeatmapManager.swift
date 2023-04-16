//
//  BeatmapStorageAdapter.swift
//  PulsePace
//
//  Created by James Chiu on 2/4/23.
//

import Foundation

/// Preloaded levels are not saved to local storage remains available in bundle only
final class BeatmapManager: ObservableObject {
    @Published var beatmapChoices: [String: RefArray<NamedBeatmap>] = [:]
    @Published var preloadedBeatmapChoices: [String: RefArray<NamedBeatmap>] = [:]
    var defaultBeatmapChoice: NamedBeatmap?
    var selectedBeatmap: Beatmap?
    var isPreloadedOnly = false
    var serialBeatmapsTable: [String: RefArray<SerializedNamedBeatmap>] = [:]
    let localBeatmapStorage = "beatmaps.json"
    let bundledBeatmaps = "preloadedBeatmaps"
    let beatmapDataManager: LocalDataManager<[String: RefArray<SerializedNamedBeatmap>]>

    init() {
        let beatmapDataManager = LocalDataManager<[String: RefArray<SerializedNamedBeatmap>]>()
        self.beatmapDataManager = beatmapDataManager

        self.preloadedBeatmapChoices = self.beatmapDataManager
            .readDefault(bundlePath: bundledBeatmaps, initData: [:]).mapValues { preloadSongGroup in
                preloadSongGroup.map { $0.deserialize() }
            }

        if !preloadedBeatmapChoices.isEmpty {
            if let firstSong = preloadedBeatmapChoices.keys.min(),
                let beatmapGroup = preloadedBeatmapChoices[firstSong] {
                defaultBeatmapChoice = beatmapGroup.get(0)
            }
        }

        self.beatmapDataManager.load(filename: localBeatmapStorage,
                                     initData: [:]) { [weak self] result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let serialBeatmapsTable):
                self?.serialBeatmapsTable = serialBeatmapsTable
                self?.beatmapChoices = serialBeatmapsTable.mapValues { songBeatGroup in
                    songBeatGroup.map { $0.deserialize() }
                }
            }
        }
    }

    // NOTE: Permits duplicate saves
    func saveBeatmap(namedBeatmap: NamedBeatmap) async {
        if let beatmapChoiceGroup = beatmapChoices[namedBeatmap.songTitle],
              let beatmapSerialGroup = serialBeatmapsTable[namedBeatmap.songTitle] {
            beatmapChoiceGroup.add(namedBeatmap)
            beatmapSerialGroup.add(namedBeatmap.serialize())
        } else {
            beatmapChoices[namedBeatmap.songTitle] = RefArray([namedBeatmap])
            serialBeatmapsTable[namedBeatmap.songTitle] = RefArray([namedBeatmap.serialize()])
        }

        beatmapDataManager.save(values: serialBeatmapsTable, filename: localBeatmapStorage) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
}

struct NamedBeatmap: Serializable {
    let mapTitle: String
    let songTitle: String
    let beatmap: Beatmap

    func serialize() -> SerializedNamedBeatmap {
        SerializedNamedBeatmap(mapTitle: mapTitle, songTitle: songTitle, serializedBeatmap: beatmap.serialize())
    }
}

struct SerializedNamedBeatmap: Deserializable {
    let mapTitle: String
    let songTitle: String
    let serializedBeatmap: SerializedBeatmap

    func deserialize() -> NamedBeatmap {
        NamedBeatmap(mapTitle: mapTitle, songTitle: songTitle, beatmap: serializedBeatmap.deserialize())
    }
}
