//
//  Adapted from https://stackoverflow.com/a/62544642
//
//  LargeButtonView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/06.
//

import SwiftUI

struct LargeButtonView: View {

    var backgroundColor: Color
    var foregroundColor: Color

    private let maxWidth: Double
    private let title: String
    private let action: () -> Void
    private let disabled: Bool

    init(title: String,
         disabled: Bool = false,
         maxWidth: Double = .infinity,
         backgroundColor: Color = .white,
         foregroundColor: Color = .purple,
         action: @escaping () -> Void) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.maxWidth = maxWidth
        self.title = title
        self.action = action
        self.disabled = disabled
    }

    var body: some View {
        HStack {
            Button(action: self.action) {
                Text(self.title)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(LargeButtonStyle(backgroundColor: backgroundColor,
                                          foregroundColor: foregroundColor,
                                          isDisabled: disabled))
            .disabled(self.disabled)
        }
        .frame(maxWidth: maxWidth)
    }
}

struct LargeButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let isDisabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        let currentForegroundColor = isDisabled || configuration.isPressed
            ? foregroundColor.opacity(0.3)
            : foregroundColor
        return configuration.label
            .padding()
            .foregroundColor(currentForegroundColor)
            .background(isDisabled || configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(currentForegroundColor, lineWidth: 1)
            )
            .font(Font.system(size: 18, weight: .semibold))
    }
}
