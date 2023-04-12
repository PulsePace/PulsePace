//
//  SongData.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/11.
//

import Foundation
import AVKit

struct SongData {
    var track: String
    var bpm: Double
    var offset: Double

    init(
        track: String,
        bpm: Double,
        offset: Double
    ) {
        self.track = track
        self.bpm = bpm
        self.offset = offset
    }

    private var playerItem: AVPlayerItem? {
        guard let url = url else {
            return nil
        }
        return AVPlayerItem(url: url)
    }

    private var metadataList: [AVMetadataItem] {
        get async {
            do {
                return try await playerItem?.asset.load(.metadata) ?? []
            } catch {
                print(error)
                return []
            }
        }
    }

    private var url: URL? {
        Bundle.main.url(forResource: track, withExtension: "m4a")
    }

    var title: String {
        get async {
            do {
                return try await metadataList
                    .first(where: { $0.commonKey?.rawValue == "title" })?
                    .load(.value) as? String ?? "Unknown Title"
            } catch {
                print(error)
                return ""
            }
        }
    }

    var artist: String {
        get async {
            do {
                return try await metadataList
                    .first(where: { $0.commonKey?.rawValue == "artist" })?
                    .load(.value) as? String ?? "Unknown Artist"
            } catch {
                print(error)
                return "Unknown Artist"
            }
        }
    }

    var thumbnailData: Data {
        get async {
            do {
                return try await metadataList
                    .first(where: { $0.commonKey?.rawValue == "artwork" })?
                    .load(.dataValue) ?? .init()
            } catch {
                print(error)
                return .init()
            }
        }
    }
}
