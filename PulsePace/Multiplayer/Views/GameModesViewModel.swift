//
//  GameModesViewModel.swift
//  PulsePace
//
//  Created by Charisma Kausar on 30/3/23.
//

import Foundation

class GameModesViewModel: ObservableObject {
    var gameModes: [GameMode] = [
        GameMode(image: "", category: "Singleplayer", title: "Classic Mode",
                 caption: "Tap, Slide, Hold, Win!", page: Page.playPage),
        GameMode(image: "", category: "Multiplayer", title: "Beat-Off",
                 caption: "Battle your friends with rhythm and strategy!", page: Page.lobbyPage)
    ]
}
