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
    let spacing: CGFloat

    init(object: HoldHitObject, cursorTime: Double, spacing: CGFloat) {
        self.position = object.position
        self.startTime = object.startTime
        self.endTime = object.endTime
        self.cursorTime = cursorTime
        self.spacing = spacing
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

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)

        }
        .position(.zero)
        .offset(x: (position.x * spacing) / 40, y: (position.y * spacing) / 40)
        .opacity(max(0, 1 - 0.5 * abs(timeDifference)))
    }
}

struct HoldHitObjectCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let object = HoldHitObject(position: .zero, startTime: 0, endTime: 0)
        let cursorTime: Double = 0
        let spacing: CGFloat = 40
        HoldHitObjectCanvasView(object: object, cursorTime: cursorTime, spacing: spacing)
    }
}
