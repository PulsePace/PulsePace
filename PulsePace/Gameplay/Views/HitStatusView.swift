//
//  HitStatusView.swift
//  PulsePace
//
//  Created by YX Z on 9/4/23.
//

import Foundation
import SwiftUI

struct HitStatusView: View {
    @EnvironmentObject var gameVM: GameViewModel
    @State private var shouldAnimate = false
    @State private var offset = 0.0
    @State private var opacity = 1.0

    var body: some View {
        Text(gameVM.hitStatus)
            .font(Fonts.caption)
            .zIndex(20)
            .foregroundColor(getColorForIndex(gameVM.gameEngine?.scoreManager.latestHitStatus))
            .scaleEffect(shouldAnimate ? 2 : 1)
            .opacity(opacity)
            .onAppear {
                let animation = Animation.easeInOut(duration: 0.2).repeatCount(1, autoreverses: true)
                withAnimation(animation) {
                    shouldAnimate = true
                    opacity = 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(animation) {
                        shouldAnimate = false
                        opacity = 0
                    }
                }
            }
            .id(gameVM.hoCount)
            .padding(60)
    }

    func getColorForIndex(_ status: HitStatus?) -> Color {
        guard let status = status else {
            return Color.white
        }
        switch status {
        case .perfect:
            return Color.orange
        case .good:
            return Color.green
        case .miss:
            return Color.gray
        case .death:
            return Color.red
        }
    }
}
