//
//  GameEndView.swift
//  PulsePace
//
//  Created by James Chiu on 10/4/23.
//

import Foundation
import SwiftUI

struct GameEndView: View {
    @EnvironmentObject var gameVM: GameViewModel
    @Binding var path: [Page]

    var body: some View {
        getScoreDisplay()
            .foregroundColor(.white)
            .font(Fonts.title)
            .fontWeight(.bold)
            .padding(.horizontal, 60)
            .padding(.vertical, 35)
            .background(.purple)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.yellow, lineWidth: 5)
            )
            .shadow(radius: 10)
    }

    func getScoreDisplay() -> some View {
        if gameVM.selectedGameMode.modeName == "Classic"
            || gameVM.selectedGameMode.modeName == "Rhythm Battle"
            || gameVM.selectedGameMode.modeName == "Infinite Mode" {
            return VStack(spacing: 15) {
                Text("Final Score")
                Text(gameVM.gameEndScore)
                StyledButton(action: { path.removeAll() }, text: "MENU", color: .orange)
            }
        } else if gameVM.selectedGameMode.modeName == "Basic Coop" {
            return VStack(spacing: 15) {
                Text("Coop Score")
                Text(gameVM.gameEndScore)
                StyledButton(action: { path.removeAll() }, text: "MENU", color: .orange)
            }
        } else {
            fatalError("Mode not supported")
        }
    }
}
