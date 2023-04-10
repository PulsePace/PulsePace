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

    var body: some View {
        Text(gameVM.hitStatus)
            .font(Fonts.caption)
            .zIndex(20)
            .foregroundColor(getColorForIndex(gameVM.gameEngine?.scoreManager.latestHitStatus))
            .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            .id(gameVM.hitStatus)
            .transition(.slide)
            .padding(20)
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
        }
    }
}
