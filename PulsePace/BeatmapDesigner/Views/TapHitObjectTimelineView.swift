//
//  TapHitObjectTimelineView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import SwiftUI

struct TapHitObjectTimelineView: HitObjectTimelineView {
    let startTime: Double
    let endTime: Double
    let beatOffset: Double
    let zoom: Double

    init(object: TapHitObject, beatOffset: Double, zoom: Double) {
        self.startTime = object.startTime
        self.endTime = object.endTime
        self.beatOffset = beatOffset
        self.zoom = zoom
    }

    var body: some View {
        Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(Circle().fill(.white))
            .frame(width: 40, height: 40)
            .offset(x: (startTime + beatOffset) * zoom)
    }
}

struct TapHitObjectTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let object = TapHitObject(position: .zero, startTime: 0)
        let beatOffset: Double = 0
        let zoom: Double = 128
        TapHitObjectTimelineView(
            object: object,
            beatOffset: beatOffset,
            zoom: zoom
        )
    }
}
