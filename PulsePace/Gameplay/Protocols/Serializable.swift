//
//  Serializable.swift
//  PulsePace
//
//  Created by James Chiu on 2/4/23.
//

import Foundation

protocol Serializable {
    associatedtype SerialType: Deserializable
    func serialize() -> SerialType
}

protocol Deserializable: Codable {
    associatedtype DeserialType: Serializable
    func deserialize() -> DeserialType
}

extension Deserializable {
    static var label: String {
        String(describing: Self.self)
    }

    var typeLabel: String {
        Self.label
    }
}

// Use case: See Beatmap and SerializedBeatmap
struct HOLabelAndData: Codable {
    let typeLabel: String
    let data: String
}

final class HOTypeFactory: Factory {
    static var isPopulated = false
    static var assemblies: [String: (String) -> any SerializedHO] = [:]

    private static func addHOAssembly(hOTypeLabel: String, assembler: @escaping (String) -> any SerializedHO) {
        assemblies[hOTypeLabel] = assembler
    }

    static func populate() {
        if isPopulated {
            return
        }
        isPopulated = true
        addHOAssembly(hOTypeLabel: SerializedTapHO.label, assembler: SerializedTapHO.decoderAssembly)
        addHOAssembly(hOTypeLabel: SerializedSlideHO.label, assembler: SerializedSlideHO.decoderAssembly)
        addHOAssembly(hOTypeLabel: SerializedHoldHO.label, assembler: SerializedHoldHO.decoderAssembly)
    }

    static func assemble(hOTypeLabel: String, data: String) -> any SerializedHO {
        if !isPopulated {
            populate()
        }

        guard let assembler = assemblies[hOTypeLabel] else {
            fatalError("Hit object assembler for \(hOTypeLabel) not found")
        }

        return assembler(data)
    }
}
