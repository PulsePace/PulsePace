//
//  GameMode.swift
//  PulsePace
//
//  Created by Charisma Kausar on 30/3/23.
//

struct GameMode: CardDisplayable {
    var image: String
    var category: String
    var title: String
    var caption: String
    var page: Page
    // metaInfo is modeName used to retrieve correct mode from ModeFactory
    let metaInfo: String
}
