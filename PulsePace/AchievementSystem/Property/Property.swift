//
//  Property.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/26.
//

import Foundation

protocol Property: Observable {
    associatedtype T
    var name: String { get }
    var value: T { get set }
}

extension Property {
    func updateValue(to value: T) {
        self.value = value
        notifyObservers()
    }
}
