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
        VStack(spacing: 4) {
            SystemIconButtonView(systemName: "plus.circle.fill", color: .white) {
                beatmapDesigner.increaseZoom()
            }
            SystemIconButtonView(systemName: "minus.circle.fill", color: .white) {
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
