//
//  GestureModifier.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import SwiftUI

struct GestureModifier<T: TouchInput>: ViewModifier where T.InputGesture.Value: Equatable,
                                                            T.InputGesture.Value: Locatable {
    var input: T
    var command: InputCommand

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(input.gesture
                .onChanged { value in
                    let inputData = InputData(value: value)
                    command.executeAction(inputData: inputData)
                }
                .onEnded { value in
                    let inputData = InputData(value: value)
                    command.executeCompletion(inputData: inputData)
                    print("Ended")
                }
            )
    }
}
