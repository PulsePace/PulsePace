//
//  LobbyDataManager.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

import Foundation
import FirebaseDatabase

class LobbyDataManager {
    private let lobbyDatabase: any DatabaseAdapter<Lobby>
    private let playerDatabase: any DatabaseAdapter<Player>
    private var lobby: Lobby?

    init(databaseAdapter: any DatabaseAdapter<Lobby>) {
        self.lobbyDatabase = databaseAdapter
        self.playerDatabase = FirebaseDatabase<Player>() // TODO: remove
    }

    func createLobby(lobby: Lobby) {
        self.lobby = lobby
        let lobbyPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobby.lobbyId])

        lobbyDatabase.saveData(path: lobbyPath, data: lobby) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                print(error)
            }
        }
    }

    func joinLobby(lobbyId: String, player: Player) {
        setLobby(lobbyId: lobbyId)

        let playersPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobbyId,
                                                           DatabasePath.players])
        let gameConfig = CompetitiveMultiplayerConfig()
        lobbyDatabase.runTransactionBlock(
            path: playersPath,
            updateBlock: { mutablePlayers -> TransactionResult in
                if mutablePlayers.childrenCount < gameConfig.maxPlayerCount,
                   var newPlayers = mutablePlayers.value as? [String: AnyObject] { // TODO: Array type-casting
                    do {
                        let jsonData = try JSONEncoder().encode(player)
                        let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                        newPlayers[player.playerId] = dict as? AnyObject
                        mutablePlayers.value = newPlayers
                        return TransactionResult.success(withValue: mutablePlayers)
                    } catch {}
                }
                return TransactionResult.success(withValue: mutablePlayers)
            },
            completion: { _ in })
    }

    private func setLobby(lobbyId: String) {
        let lobbyPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobbyId])
        let playersPath = DatabasePath.getPath(fromPaths: [lobbyPath, DatabasePath.players])

        lobbyDatabase.fetchData(path: lobbyPath, completion: { [weak self] result in
            switch result {
            case .success(let value):
                self?.lobby = value
            case .failure(let error):
                print(error)
                return
            }
        })

        playerDatabase.fetchAllData(path: playersPath, completion: { [weak self] result in
            switch result {
            case .success(let player):
                self?.lobby?.players[player.playerId] = player
            case .failure(let error):
                print(error)
                return
            }
        })
    }
}
