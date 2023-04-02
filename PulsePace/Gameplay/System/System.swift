//
//  System.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

protocol System: AnyObject {
    // register to listen to events
    func registerEventHandlers(eventManager: EventManagable)
}
