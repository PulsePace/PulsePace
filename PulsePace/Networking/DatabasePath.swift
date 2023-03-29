//
//  DatabasePath.swift
//  PulsePace
//
//  Created by Charisma Kausar on 29/3/23.
//

enum DatabasePath {
    static let lobbies = "lobbies"
    static let matches = "matches"
    static let players = "players"

    static func getPath(fromPaths: [String]) -> String {
        var concatPath = ""
        for path in fromPaths {
            concatPath += path + "/"
        }
        concatPath.removeLast()
        return concatPath
    }
}
