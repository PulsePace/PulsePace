//
//  GameplayAreaView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 16/3/23.
//

import SwiftUI

struct GameplayAreaView: View {
    var body: some View {
        ZStack {
            HStack {
                Circle()
                    .foregroundColor(.purple)
                    .modifier(GestureModifier(input: TapInput(), command: TapCommand()))
                Circle()
                    .foregroundColor(.blue)
                    .modifier(GestureModifier(input: SlideInput(), command: SlideCommand()))
                Circle()
                    .foregroundColor(.mint)
                    .modifier(GestureModifier(input: HoldInput(), command: HoldCommand()))
                Circle()
                    .foregroundColor(.indigo)
                    .modifier(GestureModifier(input: SpinInput(), command: SpinCommand()))
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(.black)
    }
}

struct GameplayAreaView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayAreaView()
    }
}
