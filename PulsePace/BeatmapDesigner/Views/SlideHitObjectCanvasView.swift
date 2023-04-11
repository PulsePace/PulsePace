//
//  SlideHitObjectCanvasView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import SwiftUI

struct SlideHitObjectCanvasView: HitObjectCanvasView {
    let position: CGPoint
    let startTime: Double
    let endTime: Double
    let vertices: [CGPoint]
    let cursorTime: Double
    let spacing: CGFloat

    init(object: SlideHitObject, cursorTime: Double, spacing: CGFloat) {
        self.position = object.position
        self.startTime = object.startTime
        self.endTime = object.endTime
        self.vertices = object.vertices
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

    var actualPositions: [CGPoint] {
        ([position] + vertices).map { (position: CGPoint) -> CGPoint in
            let actualXOffset = (position.x * spacing) / 40
            let actualYOffset = (position.y * spacing) / 40
            return CGPoint(x: actualXOffset, y: actualYOffset)
        }
    }

    var body: some View {
        ZStack {
            DrawShapeBorder(points: actualPositions).stroked(
                strokeColor: Color(hex: 0x6A229D), strokeWidth: 100, borderWidth: 10
            )

            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: min(800, max(100, 100 + 200 * timeDifference)),
                       height: min(800, max(100, 100 + 200 * timeDifference)))
                .position(x: (position.x * spacing) / 40, y: (position.y * spacing) / 40)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: (position.x * spacing) / 40, y: (position.y * spacing) / 40)

            if let lastVertex = vertices.last {
                Circle()
                    .fill(.white)
                    .frame(width: 100, height: 100)
                    .position(x: (lastVertex.x * spacing) / 40, y: (lastVertex.y * spacing) / 40)
            }

            ForEach(vertices, id: \.self) { position in
                Circle()
                    .fill(.white)
                    .frame(width: 20, height: 20)
                    .position(x: (position.x * spacing) / 40,
                              y: (position.y * spacing) / 40) // TODO: constants
            }
        }
        .opacity(max(0, 1 - 0.5 * abs(timeDifference)))
    }
}

struct SlideHitObjectCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let object = SlideHitObject(position: .zero, startTime: 0, endTime: 0, vertices: [])
        let cursorTime: Double = 0
        let spacing: CGFloat = 40
        SlideHitObjectCanvasView(object: object, cursorTime: cursorTime, spacing: spacing)
    }
}
