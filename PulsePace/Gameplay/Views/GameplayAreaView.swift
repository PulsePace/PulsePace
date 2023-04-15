//
//  GameplayAreaView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

import SwiftUI

struct GameplayAreaView: View {
    @EnvironmentObject var gameVM: GameViewModel
    var body: some View {
        ZStack {
            renderSlideGameHO(slideGameHOVMs: gameVM.slideGameHOs)
            renderTapGameHO(tapGameHOVMs: gameVM.tapGameHOs)
            renderHoldGameHO(holdGameHOVMs: gameVM.holdGameHOs)
        }
        .zIndex(200)
        .frame(
            maxWidth: 640,
            maxHeight: 480,
            alignment: .topLeading
        )
    }

    func renderSlideGameHO(slideGameHOVMs: [SlideGameHOVM]) -> some View {
        ZStack {
            ForEach(slideGameHOVMs) { slideGameHOVM in
                if slideGameHOVM.opacity > 0 {
                    SlideGameHOView(slideGameHOVM: slideGameHOVM)
                }
            }
        }
    }

    func renderHoldGameHO(holdGameHOVMs: [HoldGameHOVM]) -> some View {
        ZStack {
            ForEach(holdGameHOVMs) { holdGameHOVM in
                if holdGameHOVM.opacity > 0 {
                    HoldGameHOView(holdGameHOVM: holdGameHOVM)
                }
            }
        }
    }

    func renderTapGameHO(tapGameHOVMs: [TapGameHOVM]) -> some View {
        ZStack {
            ForEach(tapGameHOVMs) { tapGameHOVM in
                if tapGameHOVM.opacity > 0 {
                    TapGameHOView(tapGameHOVM: tapGameHOVM)
                }
            }
        }
    }
}
