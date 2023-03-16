//
//  ZoomButtonsView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/15.
//

import SwiftUI

struct ZoomButtonsView: View {
    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel

    var body: some View {
        VStack {
            SystemIconButtonView(systemName: "plus.circle.fill") {
                beatmapDesigner.increaseZoom()
            }
            SystemIconButtonView(systemName: "minus.circle.fill") {
                beatmapDesigner.decreaseZoom()
            }
        }
        .zIndex(.infinity)
    }
}

struct ZoomButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ZoomButtonsView()
    }
}
