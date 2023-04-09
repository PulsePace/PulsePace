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
    let spacing: CGFloat

    init(object: TapHitObject, cursorTime: Double, spacing: CGFloat) {
        self.position = object.position
        self.startTime = object.startTime
        self.endTime = object.startTime
        self.cursorTime = cursorTime
        self.spacing = spacing
    }

    var body: some View {
        let timeDifference = startTime - cursorTime

        return ZStack {
            // TODO: fix
            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: min(800, max(spacing * 2, spacing * 2 + 200 * timeDifference)),
                       height: min(800, max(spacing * 2, spacing * 2 + 200 * timeDifference)))

            Circle()
                .fill(.white)
                .frame(width: spacing * 2, height: spacing * 2)

        }
        .position(.zero)
        .offset(x: (position.x * spacing) / 40, y: (position.y * spacing) / 40)
        .opacity(max(0, 1 - 0.5 * abs(timeDifference)))
    }
}

struct TapHitObjectCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let object = TapHitObject(position: .zero, startTime: 0)
        let cursorTime: Double = 0
        let spacing: CGFloat = 40
        TapHitObjectCanvasView(
            object: object,
            cursorTime: cursorTime,
            spacing: spacing
        )
    }
}
