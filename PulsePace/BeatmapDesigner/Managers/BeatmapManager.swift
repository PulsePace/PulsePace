//
//  BeatmapStorageAdapter.swift
//  PulsePace
//
//  Created by James Chiu on 2/4/23.
//

import Foundation

final class BeatmapManager: ObservableObject {
    @Published var beatmapChoices: [NamedBeatmap] = []
    var serialBeatmaps: [SerializedNamedBeatmap] = []
    let localBeatmapStorage = "beatmaps.json"
    let bundledBeatmaps = "preloadedBeatmaps"
    let beatmapDataManager: LocalDataManager<[SerializedNamedBeatmap]>

    init() {
        let beatmapDataManager = LocalDataManager<[SerializedNamedBeatmap]>(
            fileName: localBeatmapStorage, bundlePath: bundledBeatmaps)
        self.beatmapDataManager = beatmapDataManager
        self.beatmapDataManager.load(filename: localBeatmapStorage,
                                     bundlePath: bundledBeatmaps, initData: []) { [weak self] result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let serialBeatmaps):
                self?.serialBeatmaps = serialBeatmaps
                self?.beatmapChoices = serialBeatmaps.map { $0.deserialize() }
            }
        }
    }

    // NOTE: Permits duplicate saves
    func saveBeatmap(namedBeatmap: NamedBeatmap) {
        print(namedBeatmap.serialize())
        beatmapChoices.append(namedBeatmap)
        serialBeatmaps.append(namedBeatmap.serialize())
        beatmapDataManager.save(values: serialBeatmaps, filename: localBeatmapStorage) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
}

struct NamedBeatmap: Serializable {
    let songTitle: String
    let beatmap: Beatmap

    func serialize() -> SerializedNamedBeatmap {
        SerializedNamedBeatmap(songTitle: songTitle, serializedBeatmap: beatmap.serialize())
    }
}

struct SerializedNamedBeatmap: Deserializable {
    let songTitle: String
    let serializedBeatmap: SerializedBeatmap

    func deserialize() -> NamedBeatmap {
        NamedBeatmap(songTitle: songTitle, beatmap: serializedBeatmap.deserialize())
    }
}
