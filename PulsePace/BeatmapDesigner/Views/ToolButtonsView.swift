//
//  ToolButtonsView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/06.
//

import SwiftUI

struct ToolButtonsView: View {
    @EnvironmentObject var beatmapDesigner: BeatmapDesignerViewModel

    var body: some View {
        VStack(spacing: 20) {
            ForEach(beatmapDesigner.gestureHandlerList, id: \.title) { gestureHandler in
                let isSelected = beatmapDesigner.gestureHandler.title == gestureHandler.title
                LargeButtonView(
                    title: gestureHandler.title,
                    maxWidth: 120,
                    backgroundColor: isSelected ? .white : .white.opacity(0.5)
                ) {
                    beatmapDesigner.gestureHandler = gestureHandler
                }
            }
        }
        .padding(.leading, 20)
    }
}

struct ToolButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolButtonsView()
    }
}
