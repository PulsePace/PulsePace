//
//  DrawShapeBorder.swift
//  PulsePace
//  Adapted from https://stackoverflow.com/a/67341460
//
//  Created by Peter Jung on 2023/03/17.
//

import Foundation
import SwiftUI

struct DrawShapeBorder: Shape {
    var points: [CGPoint]

    func stroked(strokeColor: Color, strokeWidth: Double, borderWidth: Double) -> some View {
        ZStack {
            self.stroke(.blue,
                        style: StrokeStyle(lineWidth: strokeWidth + borderWidth * 2, lineCap: .round, lineJoin: .round))
            self.stroke(.white,
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
                .compositingGroup()
                .blendMode(.difference)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let startingPoint = points.first else {
            return path
        }
        path.move(to: startingPoint)

        for pointLocation in points {
            path.addLine(to: pointLocation)
        }

        return path
    }
}
