//
//  PressAnimation.swift
//  PulsePace
//
//  Created by YX Z on 9/4/23.
//

import Foundation
import SwiftUI

struct GestureAnimation<T: TouchInput>: ViewModifier where T.InputGesture.Value: Equatable,
                                                           T.InputGesture.Value: Locatable {
    var input: T
    var onPress: () -> Void
    var onRelease: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                input.gesture
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}
