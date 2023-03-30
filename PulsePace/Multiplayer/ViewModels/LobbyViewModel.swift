//
//  LobbyViewModel.swift
//  PulsePace
//
//  Created by Charisma Kausar on 30/3/23.
//

import Foundation

class LobbyViewModel: ObservableObject {
    var lobby: Lobby?
    func createLobby() {
        lobby = Lobby()
    }
}
