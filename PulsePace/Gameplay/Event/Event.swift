//
//  Event.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

protocol Event {
    var timestamp: Double { get }
}

extension Event {
    static var label: String {
        String(describing: Self.self)
    }
}
