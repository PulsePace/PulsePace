//
//  PropertyStorage.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/15.
//

import Foundation

final class PropertyStorage: MetricsStorable {
    private(set) var beatmapDesignerOpened = GameProperty(name: "Beatmap Designer Opened", value: 0)
    private(set) var hitObjectsPlaced = GameProperty(name: "Hit Objects Placed", value: 0)
    private(set) var lifetimeScore = GameProperty(name: "Lifetime Score", value: 0)

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(openBeatmapDesignerHandler)
        eventManager.registerHandler(placeHitObjectHandler)
        eventManager.registerHandler(clearHitObjectHandler)
    }

    var properties: [any Property] {
        [
            beatmapDesignerOpened,
            hitObjectsPlaced,
            lifetimeScore
        ]
    }

    // handler not tied to property as handler may update multiple properties
    private lazy var openBeatmapDesignerHandler = { [self] (_: EventManagable, _: OpenBeatmapDesignerEvent) -> Void in
        beatmapDesignerOpened.value += 1
    }

    private lazy var placeHitObjectHandler = { [self] (_: EventManagable, _: PlaceHitObjectEvent) -> Void in
        hitObjectsPlaced.value += 1
    }

    private lazy var clearHitObjectHandler = { [self] (_: EventManagable, event: UpdateComboEvent) -> Void in
        lifetimeScore.value += event.score
    }
}
