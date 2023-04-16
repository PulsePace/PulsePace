//
//  GameProperty.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/26.
//

import Foundation

struct GameProperty<T>: Property {
    var name: String
    var value: T
}

protocol Property {
    associatedtype T
    var name: String { get }
    var value: T { get set }
}

extension Property {
    var displayValue: String {
        if let value = value as? CustomStringConvertible {
            return value.description
        } else {
            return ""
        }
    }
}
