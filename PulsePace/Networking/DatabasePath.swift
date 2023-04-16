//
//  DatabasePath.swift
//  PulsePace
//
//  Created by Charisma Kausar on 29/3/23.
//

enum DatabasePath {
    static let lobbies = "lobbies"
    static let players = "players"
    static let lobbyStatus = "lobbyStatus"
    static let modeName = "modeName"
    static let preMatchData = "preMatchData"

    static let matches = "matches"
    static let events = "events"

    static func getPath(fromPaths: [String]) -> String {
        var concatPath = ""
        for path in fromPaths {
            concatPath += path + "/"
        }
        concatPath.removeLast()
        return concatPath
    }
}
