//
//  LobbyDataManager.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

import Foundation
import FirebaseDatabase

class LobbyDataManager {
    private let databaseAdapter: any DatabaseAdapter<Lobby>
    private var lobby: Lobby?

    init(databaseAdapter: any DatabaseAdapter<Lobby>) {
        self.databaseAdapter = databaseAdapter
    }

    func createLobby(lobby: Lobby) {
        self.lobby = lobby
        databaseAdapter.saveData(path: DatabasePath.lobbies, data: lobby) { _ in }
    }

    func joinLobby(lobbyId: String, player: Player) {
        setLobby(lobbyId: lobbyId)
        guard let lobby = lobby else {
            return
        }

        let playersPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobbyId,
                                                           DatabasePath.players])
        databaseAdapter.runTransactionBlock(
            path: playersPath,
            updateBlock: { mutablePlayers -> TransactionResult in
                guard
                    mutablePlayers.childrenCount >= lobby.config.maxPlayerCount,
                    var newPlayers = mutablePlayers.value as? [String: AnyObject]
                else {
                    return TransactionResult.abort()
                }
                newPlayers[player.playerId] = player as AnyObject?
                mutablePlayers.value = newPlayers
                return TransactionResult.success(withValue: mutablePlayers)
            },
            completion: { _ in })
    }

    private func setLobby(lobbyId: String) {
        let lobbyPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobbyId])
        databaseAdapter.fetchData(path: lobbyPath, completion: { [weak self] result in
            switch result {
            case .success(let value):
                self?.lobby = value
            case .failure(let error):
                print(error)
                return
            }
        })
    }
}
