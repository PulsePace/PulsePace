//
//  BaseGameHO.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

// Since we are only going to have hitObjects as gameObjects bounding T by GameHO should be fine
class Entity: Identifiable, Hashable {
    let id: Int64
    let remover: (Entity) -> Void

    init(id: Int64, remover: @escaping (Entity) -> Void) {
        self.id = id
        self.remover = remover
    }

    static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func destroy() {
        remover(self)
    }
}
