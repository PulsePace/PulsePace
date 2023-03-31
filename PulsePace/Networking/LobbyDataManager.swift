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
        self.lobbyListener = FirebaseListener<Lobby>() // TODO: remove
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
            case .failure(let error):
                print(error)
            }
        }
    }

    func joinLobby(lobby: Lobby, player: Player) {
        self.lobby = lobby

        let playersPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobby.lobbyId,
                                                           DatabasePath.players])
        let gameConfig = CompetitiveMultiplayerConfig()
        lobbyDatabase.runTransactionBlock(
            at: playersPath,
            updateBlock: { mutablePlayers -> TransactionResult in
                if mutablePlayers.childrenCount < gameConfig.maxPlayerCount,
                   var newPlayers = mutablePlayers.value as? [String: AnyObject] {
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
            completion: { [weak self] _ in
                self?.setupListeners()
            })
    }

    func startMatch(match: Match) {
        guard let lobby = lobby else {
            return
        }
        let lobbyStatusPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobby.lobbyId,
                                                               DatabasePath.lobbyStatus])
        lobbyDatabase.setValue(at: lobbyStatusPath, value: LobbyStatus.matchStarted.rawValue) { _ in }
    }

    private func setupListeners() {
        guard let lobby = lobby else {
            return
        }

        self.setLobbyPlayers(lobbyId: lobby.lobbyId)
        self.observeLobbyStatus(lobbyId: lobby.lobbyId)
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

    private func observeLobbyStatus(lobbyId: String) {
        let lobbyPath = DatabasePath.getPath(fromPaths: [DatabasePath.lobbies, lobbyId])
        let lobbyStatusChangedHandler: (Result<Lobby, Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let lobby):
                self?.lobby?.lobbyStatus = lobby.lobbyStatus
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
