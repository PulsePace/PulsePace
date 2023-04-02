//
//  HitObject.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import Foundation

protocol HitObject: AnyObject, Identifiable, Serializable {
    var position: CGPoint { get set }
    var startTime: Double { get set }
    var endTime: Double { get set }
}

// MARK: - Identifiable
extension HitObject {
    var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}

protocol SerializedHO: Deserializable where DeserialType: HitObject {
    var position: CGPoint { get set }
    var startTime: Double { get set }
    var endTime: Double { get set }

    static var decoderAssembly: (String) -> Self { get set }
}

struct SerializedTapHO: SerializedHO {
    typealias DeserialType = TapHitObject
    var position: CGPoint
    var startTime: Double
    var endTime: Double

    static var decoderAssembly = { (encodedData: String) -> SerializedTapHO in
        guard let data = encodedData.data(using: .utf8) else {
            fatalError("Data not decodable check for consistent schemes")
        }
        do {
            return try JSONDecoder().decode(SerializedTapHO.self, from: data)
        } catch {
            fatalError("Fuck all this error handling")
        }
    }

    init(tapHO: TapHitObject) {
        position = tapHO.position
        startTime = tapHO.startTime
        endTime = tapHO.endTime
    }

    func deserialize() -> TapHitObject {
        TapHitObject(position: position, startTime: startTime)
    }
}

struct SerializedSlideHO: SerializedHO {
    typealias DeserialType = SlideHitObject
    var position: CGPoint
    var startTime: Double
    var endTime: Double
    var vertices: [CGPoint]

    static var decoderAssembly = { (encodedData: String) -> SerializedSlideHO in
        guard let data = encodedData.data(using: .utf8) else {
            fatalError("Data not decodable check for consistent schemes")
        }
        do {
            return try JSONDecoder().decode(SerializedSlideHO.self, from: data)
        } catch {
            fatalError("Fuck all this error handling")
        }
    }

    init(slideHO: SlideHitObject) {
        position = slideHO.position
        startTime = slideHO.startTime
        endTime = slideHO.endTime
        vertices = slideHO.vertices
    }

    func deserialize() -> SlideHitObject {
        SlideHitObject(position: position, startTime: startTime, endTime: endTime, vertices: vertices)
    }
}

struct SerializedHoldHO: SerializedHO {
    typealias DeserialType = HoldHitObject
    var position: CGPoint
    var startTime: Double
    var endTime: Double

    static var decoderAssembly = { (encodedData: String) -> SerializedHoldHO in
        guard let data = encodedData.data(using: .utf8) else {
            fatalError("Data not decodable check for consistent schemes")
        }
        do {
            return try JSONDecoder().decode(SerializedHoldHO.self, from: data)
        } catch {
            fatalError("Fuck all this error handling")
        }
    }

    init(holdHO: HoldHitObject) {
        position = holdHO.position
        startTime = holdHO.startTime
        endTime = holdHO.endTime
    }

    func deserialize() -> HoldHitObject {
        HoldHitObject(position: position, startTime: startTime, endTime: endTime)
    }
}
