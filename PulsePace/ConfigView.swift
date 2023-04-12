//
//  ConfigView.swift
//  PulsePace
//
//  Created by James Chiu on 9/4/23.
//

import Foundation
import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var userConfigManager: UserConfigManager

    var body: some View {
        HStack {
            TextField("Name", text: $userConfigManager.userConfig.name)
                .frame(maxWidth: 300)
                .textFieldStyle(.roundedBorder)

            StyledButton(action: { userConfigManager.save() }, text: "Save")
        }
    }
}

struct StyledButton: View {
    var action: () -> Void
    var text: String
    var color = Color.purple

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(minWidth: 200)
                .background(color)
                .cornerRadius(20)
                .shadow(radius: 5)
        }
    }
}
