//
//  Popup.swift
//  Peggle
//
//  Created by James Chiu on 28/2/23.
//

import Foundation
import SwiftUI

struct Popup<PopupContent>: ViewModifier where PopupContent: View {
    /// Controls if the sheet should be presented or not
    @Binding var isPresented: Bool
    @State private var presenterContentRect: CGRect = .zero
    /// The rect of popup content
    @State private var sheetContentRect: CGRect = .zero
    /// The content to present
    var view: () -> PopupContent

    init(isPresented: Binding<Bool>,
         view: @escaping () -> PopupContent) {
        self._isPresented = isPresented
        self.view = view
    }

    /// The offset when the popup is displayed
    private var displayedOffset: CGFloat {
        -presenterContentRect.midY + screenHeight / 2
    }

    /// The offset when the popup is hidden
    private var hiddenOffset: CGFloat {
        if presenterContentRect.isEmpty {
            return 1_000
        }
        return screenHeight - presenterContentRect.midY + sheetContentRect.height / 2 + 5
    }

    /// The current offset, based on the "presented" property
    private var currentOffset: CGFloat {
        isPresented ? displayedOffset : hiddenOffset
    }

    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }

    private var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .frameGetter($presenterContentRect)
        }
        .overlay(sheet())
    }

    func sheet() -> some View {
        ZStack {
            self.view()
                .simultaneousGesture(
                    TapGesture().onEnded {
                        dismiss()
                    })
                .frameGetter($sheetContentRect)
                .frame(width: screenWidth)
                .offset(x: 0, y: currentOffset)
                .animation(Animation.easeOut(duration: 0.3), value: currentOffset)
        }
    }

    private func dismiss() {
        isPresented = false
    }
}

extension View {
    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        view: @escaping () -> PopupContent) -> some View {
        self.modifier(
            Popup(isPresented: isPresented, view: view)
        )
    }
}
