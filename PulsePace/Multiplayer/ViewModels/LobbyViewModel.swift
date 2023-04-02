//
//  LobbyViewModel.swift
//  PulsePace
//
//  Created by Charisma Kausar on 30/3/23.
//

import Foundation

class LobbyViewModel: ObservableObject {
    @Published var lobby: Lobby?
    @Published var lobbyPlayers: [Player] = []
    @Published var match: Match?

    func onLobbyDataChanged() {
        guard let lobby = lobby else {
            return
        }
        lobbyPlayers = Array(lobby.players.values)
        objectWillChange.send()
    }
}
