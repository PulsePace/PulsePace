//
//  EditModeModifier.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/18.
//

import Foundation
import SwiftUI

struct EditModeModifier: ViewModifier {
    var gestureHandler: any GestureHandler

    init(beatmapDesigner: BeatmapDesignerViewModel, gestureHandler: any GestureHandler) {
        self.gestureHandler = gestureHandler
        self.gestureHandler.beatmapDesigner = beatmapDesigner
    }

    func body(content: Content) -> some View {
        AnyView(content.gesture(gestureHandler.gesture))
    }
}
