//
//  HoldHitObjectCanvasView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import SwiftUI

struct HoldHitObjectCanvasView: HitObjectCanvasView {
    let position: CGPoint
    let startTime: Double
    let endTime: Double
    let cursorTime: Double

    init(object: HoldHitObject, cursorTime: Double) {
        self.position = object.position
        self.startTime = object.startTime
        self.endTime = object.endTime
        self.cursorTime = cursorTime
    }

    var timeDifference: Double {
        if cursorTime >= startTime && cursorTime <= endTime {
            return 0
        } else {
            let diffFromStart = startTime - cursorTime
            let diffFromEnd = endTime - cursorTime
            return cursorTime < startTime ? diffFromStart : diffFromEnd
        }
    }

    var body: some View {
        ZStack {
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

struct HoldHitObjectCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let object = HoldHitObject(position: .zero, startTime: 0, endTime: 0)
        let cursorTime: Double = 0
        HoldHitObjectCanvasView(object: object, cursorTime: cursorTime)
    }
}
