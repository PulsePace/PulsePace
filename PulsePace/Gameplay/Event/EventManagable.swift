//
//  EventManagable.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

protocol EventManagable {
    typealias Handler = (EventManagable, Event) -> Void
    func add(event: Event)
    func registerHandler<T: Event>(_ handler: @escaping (EventManagable, T) -> Void)
}
