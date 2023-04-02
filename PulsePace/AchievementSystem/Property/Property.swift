//
//  Property.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/26.
//

import Foundation

protocol Property: Observable {
    associatedtype T
    associatedtype S: PropertyUpdater

    var name: String { get }
    var value: T { get set }
    var updater: S { get }
}

extension Property {
    func updateValue(to value: T) {
        self.value = value
        notifyObservers()
    }
}
