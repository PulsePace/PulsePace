//
//  System.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

protocol System: AnyObject {
    // register to listen to events
    func registerEventHandlers(eventManager: EventManagable)
    func step(deltaTime: Double, songPosition: Double)
}

extension System {
    func step(deltaTime: Double, songPosition: Double) {}
}

// Will be reused hence must have reset function
protocol ModeSystem: System {
    func reset()
}

protocol EventSource {
    var eventManager: EventManagable? { get }
}
