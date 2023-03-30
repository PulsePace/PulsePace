//
//  ButtonCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 30/3/23.
//

class ButtonCommand: Command {
    typealias ActionArguments = ()
    var action: Action

    init(action: @escaping Action) {
        self.action = action
    }
}

class CreateLobbyCommand: ButtonCommand {
    override private init(action: @escaping ButtonCommand.Action) {
        super.init(action: action)
    }

    convenience init(receiver: LobbyViewModel) {
        self.init { _ in
            receiver.lobby = Lobby()
        }
    }
}

class JoinLobbyCommand: ButtonCommand {
    override private init(action: @escaping ButtonCommand.Action) {
        super.init(action: action)
    }

    convenience init(receiver: LobbyViewModel, lobbyCode: String) {
        self.init { _ in
            receiver.lobby = Lobby(lobbyId: lobbyCode)
        }
    }
}
