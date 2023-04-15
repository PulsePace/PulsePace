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
    private let lobbyListener: any DatabaseListenerAdapter<Lobby>
    private let playersListener: any DatabaseListenerAdapter<Player>
    private var lobby: Lobby?

    private var lobbyDataChangeHandler: (() -> Void)? = {}

    init(databaseAdapter: any DatabaseAdapter<Lobby>, lobbyDataChangeHandler: (() -> Void)? = {}) {
        self.lobbyDatabase = databaseAdapter
        self.lobbyListener = FirebaseListener<Lobby>() // TODO: remove @Charisma
        self.playersListener = FirebaseListener<Player>() // TODO: remove
        self.lobbyDataChangeHandler = lobbyDataChangeHandler
    }

    func createLobby(lobby: Lobby) {
        self.lobby = lobby
        let lobbyPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobby.lobbyId])

        lobbyDatabase.saveData(at: lobbyPath, data: lobby) { [weak self] result in
            switch result {
            case .success:
                self?.setupListeners()
                self?.deleteOnDisconnect(at: lobbyPath)
            case .failure(let error):
                print(error)
            }
        }
    }

    func joinLobby(lobby: Lobby, player: Player) {
        self.lobby = lobby
        let gameConfig = lobby.roomSetting
        // TODO: Combine two queries into one
        let lobbyPath = DatabasePath.getPath(fromPaths: [
            DatabasePath.lobbies, lobby.lobbyId
        ])
        let playerPath = DatabasePath.getPath(fromPaths: [lobbyPath, DatabasePath.players, player.playerId])

        lobbyDatabase.runTransactionBlock(
            at: lobbyPath, updateBlock: { requestedLobby -> TransactionResult in
                // Check lobby at lobby id is of matching lobby type first
                if var updatedLobby = requestedLobby.value as? [String: AnyObject] {
                    if updatedLobby[DatabasePath.modeName] as? String != lobby.modeName {
                        return TransactionResult.abort()
                    }

                    guard var players = updatedLobby[DatabasePath.players] as? [String: AnyObject] else {
                        fatalError("There should be at least one player in a lobby")
                    }

                    if players.count < gameConfig.maxPlayerCount {
                         do {
                             let jsonData = try JSONEncoder().encode(player)
                             let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                             players[player.playerId] = dict as? AnyObject
                             updatedLobby[DatabasePath.players] = players as AnyObject
                             requestedLobby.value = updatedLobby
                             return TransactionResult.success(withValue: requestedLobby)
                         } catch {
                             print(error.localizedDescription)
                         }
                    }
                }
                return TransactionResult.success(withValue: requestedLobby)
            },
            completion: { [weak self] _ in
                self?.setupListeners()
                self?.deleteOnDisconnect(at: playerPath)
            }
        )
    }

    func exitLobby() {
        guard let lobby = lobby,
            let userConfigManager = UserConfigManager.instance else {
            return
        }
        if lobby.isUserHost {
            let lobbyPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobby.lobbyId])
            lobbyDatabase.deleteData(at: lobbyPath, completion: { _ in })
        } else {
            let playerPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobby.lobbyId,
                                                              DatabasePath.players, userConfigManager.userId])
            lobbyDatabase.deleteData(at: playerPath, completion: { _ in })
        }
    }

    func startMatch(match: Match) {
        guard let lobby = lobby,
              lobby.isUserHost,
              lobby.isEligibleToPlay
        else {
            return
        }
        let lobbyStatusPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobby.lobbyId,
                                                               DatabasePath.lobbyStatus])
        lobbyDatabase.setValue(at: lobbyStatusPath, value: LobbyStatus.matchStarted.rawValue) { _ in }
    }

    private func deleteOnDisconnect(at path: String) {
        lobbyDatabase.deleteDataOnDisconnect(at: path, completion: { _ in })
    }

    private func setupListeners() {
        guard let lobby = lobby else {
            return
        }

        self.setLobbyPlayers(lobbyId: lobby.lobbyId)
        self.observeLobby(lobbyId: lobby.lobbyId)
    }

    private func setLobbyPlayers(lobbyId: String) {
        let lobbyPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobbyId])
        let playersPath = DatabasePath.getPath(fromPaths: [lobbyPath, DatabasePath.players])
        let playerUpdateHandler: (Result<Player, Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let player):
                self?.lobby?.players[player.playerId] = player
                guard let changeHandler = self?.lobbyDataChangeHandler else {
                    return
                }
                changeHandler()
            case .failure(let error):
                print(error)
                return
            }
        }

        let playerLeftHandler: (Result<Player, Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let player):
                self?.lobby?.players[player.playerId] = nil
                guard let changeHandler = self?.lobbyDataChangeHandler else {
                    return
                }
                changeHandler()
            case .failure(let error):
                print(error)
                return
            }
        }

        playersListener.setupAddChildListener(in: playersPath, completion: playerUpdateHandler)
        playersListener.setupUpdateChildListener(in: playersPath, completion: playerUpdateHandler)
        playersListener.setupRemoveChildListener(in: playersPath, completion: playerLeftHandler)
    }

    private func observeLobby(lobbyId: String) {
        let lobbyPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobbyId])
        let lobbyStatusChangedHandler: (Result<Lobby, Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let lobby):
                self?.lobby?.lobbyStatus = lobby.lobbyStatus
                self?.lobby?.hostId = lobby.hostId
                self?.lobby?.modeName = lobby.modeName
                self?.lobby?.preMatchData = lobby.preMatchData
                guard let changeHandler = self?.lobbyDataChangeHandler else {
                    return
                }
                changeHandler()
            case .failure(let error):
                print(error)
                return
            }
        }
        lobbyListener.setupChildValueListener(in: lobbyPath, completion: lobbyStatusChangedHandler)
    }
}
