//
//  EventHandler.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

class EventHandler {

    var closure: (EventManagable, Event) -> Void

    init<T: Event>(closure: @escaping (EventManagable, T) -> Void, event: T.Type) {
        lazy var castedClosure = { (manager: EventManagable, e: Event) -> Void in
            guard let castedEvent = e as? T else {
                return
            }
            return closure(manager, castedEvent)
        }
        self.closure = castedClosure
    }

    func execute(eventManager: EventManagable, event: Event) {
        closure(eventManager, event)
    }
}
