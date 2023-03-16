//
//  DivisorSliderView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/15.
//

import SwiftUI

struct DivisorSliderView: View {
    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel

    var body: some View {
        VStack {
            Text("Beat Snap Divisor: 1/\(Int(beatmapDesigner.divisor))")

            Slider(
                value: $beatmapDesigner.divisorIndex,
                in: 0...Double(beatmapDesigner.divisorList.count - 1),
                step: 1
            )
            .frame(width: 200)
        }
    }
}

struct DivisorSliderView_Previews: PreviewProvider {
    static var previews: some View {
        DivisorSliderView()
    }
}
