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
    func stroked() -> some View {
        // TODO: parameterise
        ZStack {
            self.stroke(.blue, style: StrokeStyle(lineWidth: 110, lineCap: .round, lineJoin: .round))
            self.stroke(.white.opacity(0.5), style: StrokeStyle(lineWidth: 100, lineCap: .round, lineJoin: .round))
                .compositingGroup()
                .blendMode(.difference)
        }
    }

    var points: [CGPoint]

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
