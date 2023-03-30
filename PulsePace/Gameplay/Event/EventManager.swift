//
//  EventManager.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

class EventManager: EventManagable {
    var eventHandlerMap: [String: [EventHandler]] = [:]
    var eventQueue = PriorityQueue<Event> { a, b in
        a.timestamp < b.timestamp
    }

    func add(event: Event) {
        eventQueue.enqueue(event)
    }

    func registerHandler<T>(_ handler: @escaping (EventManagable, T) -> Void) where T: Event {
        let eventHandler = EventHandler(closure: handler, event: T.self)
        eventHandlerMap[T.label, default: []].append(eventHandler)
    }

    func handleAllEvents() {
        while !eventQueue.isEmpty {
            guard let event = eventQueue.dequeue(), let handlers = eventHandlerMap[type(of: event).label] else {
                return
            }
            handlers.forEach({ $0.execute(eventManager: self, event: event) })
        }
    }
}
