//
//  GameView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        VStack {
            Text("GameView")
                .font(.largeTitle)
            HStack {
                Circle()
                    .foregroundColor(.purple)
                    .modifier(GestureModifier(input: TapInput(), command: TapCommand()))
                Circle()
                    .foregroundColor(.mint)
                    .modifier(GestureModifier(input: SlideInput(), command: SlideCommand()))
                Circle()
                    .foregroundColor(.pink)
                    .modifier(GestureModifier(input: HoldInput(), command: HoldCommand()))
                Circle()
                    .foregroundColor(.blue)
                    .modifier(GestureModifier(input: SpinInput(), command: SpinCommand()))
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
