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
    @EnvironmentObject var propertyStorage: PropertyStorage

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    TextField("Name", text: $userConfigManager.userConfig.name)
                        .frame(maxWidth: 300)
                        .textFieldStyle(.roundedBorder)

                    StyledButton(action: { userConfigManager.save() }, text: "Save")
                }
                VStack {
                    ForEach(propertyStorage.properties, id: \.name) { property in
                        renderProperty(property)
                    }
                }
            }
            .padding(.init(top: 0, leading: 160, bottom: 0, trailing: 160))
        }
    }

    @ViewBuilder
    private func renderProperty(_ property: any Property) -> some View {
        HStack {
            Text(property.name)
            Spacer()
            Text(property.displayValue)
        }
        .frame(height: 80)
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
