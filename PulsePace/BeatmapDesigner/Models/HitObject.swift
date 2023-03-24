//
//  HitObject.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import Foundation

protocol HitObject: AnyObject, Identifiable {
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
