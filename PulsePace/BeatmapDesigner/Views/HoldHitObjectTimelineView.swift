//
//  HoldHitObjectTimelineView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import SwiftUI

struct HoldHitObjectTimelineView: HitObjectTimelineView {
    let startTime: Double
    let endTime: Double
    let beatOffset: Double
    let zoom: Double

    init(object: HoldHitObject, beatOffset: Double, zoom: Double) {
        self.startTime = object.startTime
        self.endTime = object.endTime
        self.beatOffset = beatOffset
        self.zoom = zoom
    }

    var body: some View {
        Rectangle()
            .strokeBorder(.black, lineWidth: 2)
            .background(.white.opacity(0.5))
            .frame(width: (endTime - startTime) * zoom, height: 40)
            .offset(x: (startTime + beatOffset) * zoom + 20)

        Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(Circle().fill(.white))
            .frame(width: 40, height: 40)
            .offset(x: (startTime + beatOffset) * zoom)

        Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(Circle().fill(.white))
            .frame(width: 40, height: 40)
            .offset(x: (endTime + beatOffset) * zoom)
    }
}

struct HoldHitObjectTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let object = HoldHitObject(position: .zero, startTime: 0, endTime: 0)
        let beatOffset: Double = 0
        let zoom: Double = 128
        HoldHitObjectTimelineView(
            object: object,
            beatOffset: beatOffset,
            zoom: zoom
        )
    }
}
