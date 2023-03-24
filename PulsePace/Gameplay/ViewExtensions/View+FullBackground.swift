//
//  View+FullBackground.swift
//  PulsePace
//
//  Created by Charisma Kausar on 12/3/23.
//

import SwiftUI

extension View {
    func fullBackground(imageName: String) -> some View {
        background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
        )
    }
}
