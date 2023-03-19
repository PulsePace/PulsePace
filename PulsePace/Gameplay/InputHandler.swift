//
//  InputHandler.swift
//  PulsePace
//
//  Created by Charisma Kausar on 19/3/23.
//

protocol InputHandler: AnyObject {
    func onTap()
    func onSlideChanged()
    func onSlideEnded()
    func onHoldChanged()
    func onHoldEnded()
}
