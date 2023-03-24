//
//  TapHitObjectCanvasView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import SwiftUI

struct TapHitObjectCanvasView: HitObjectCanvasView {
    let position: CGPoint
    let startTime: Double
    let endTime: Double
    let cursorTime: Double

    init(object: TapHitObject, cursorTime: Double) {
        self.position = object.position
        self.startTime = object.startTime
        self.endTime = object.startTime // TODO: fix
        self.cursorTime = cursorTime
    }

    var body: some View {
        let timeDifference = startTime - cursorTime

        return ZStack {
            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: min(800, max(100, 100 + 200 * timeDifference)),
                       height: min(800, max(100, 100 + 200 * timeDifference)))
                .position(x: position.x,
                          y: position.y)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: position.x,
                          y: position.y) // TODO: constants

        }
        .opacity(max(0, 1 - 0.5 * abs(timeDifference)))
    }
}

struct TapHitObjectCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let object = TapHitObject(position: .zero, startTime: 0)
        let cursorTime: Double = 0
        TapHitObjectCanvasView(object: object, cursorTime: cursorTime)
    }
}
