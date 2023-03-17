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
            Circle()
                .foregroundColor(.purple)
                .modifier(GestureModifier(input: TapInput(), command: TapCommand()))
                .frame(width: 150, height: 150)
                .position(x: 200, y: 90)
            Circle()
                .foregroundColor(.blue)
                .modifier(GestureModifier(input: SlideInput(), command: SlideCommand()))
                .frame(width: 150, height: 150)
                .position(x: 400, y: 480)
            Circle()
                .foregroundColor(.mint)
                .modifier(GestureModifier(input: HoldInput(), command: HoldCommand()))
                .frame(width: 150, height: 150)
                .position(x: 750, y: 210)
            Circle()
                .foregroundColor(.indigo)
                .modifier(GestureModifier(input: SpinInput(), command: SpinCommand()))
                .frame(width: 150, height: 150)
                .position(x: 800, y: 500)
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
