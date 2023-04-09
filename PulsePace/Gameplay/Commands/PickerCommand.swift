//
//  PickerCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 8/4/23.
//

class PickerCommand: Command {
    typealias ActionArguments = String
    var action: Action

    init(action: @escaping SelectTargetCommand.Action) {
        self.action = action
    }
}

class SelectTargetCommand: PickerCommand {
    override private init(action: @escaping SelectTargetCommand.Action) {
        super.init(action: action)
    }

    convenience init(receiver: GameViewModel) {
        self.init { target in
            receiver.setTarget(target)
        }
    }
}

class SelectDisruptorCommand: PickerCommand {
    override private init(action: @escaping SelectDisruptorCommand.Action) {
        super.init(action: action)
    }

    convenience init(receiver: GameViewModel) {
        self.init { disruptor in
            receiver.setDisruptor(Disruptor(rawValue: disruptor) ?? .bomb)
        }
    }
}
