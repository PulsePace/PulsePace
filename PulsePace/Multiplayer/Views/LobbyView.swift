//
//  LobbyView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 30/3/23.
//

import SwiftUI
import Combine

struct LobbyView: View {
    @StateObject var viewModel = LobbyViewModel()
    @State private var lobbyCode: String = ""

    var body: some View {
        VStack {
            renderLobbyControls()
        }
    }

    @ViewBuilder
    private func renderLobbyControls() -> some View {
        HStack {
            StyledLobbyButton(command: CreateLobbyCommand(receiver: viewModel), text: "Create New Lobby")
            Spacer()
            Text("OR")
                .foregroundColor(.secondary)
            Spacer()
            TextField("Lobby Code", text: $lobbyCode)
                .frame(maxWidth: 300)
                .keyboardType(.numberPad)
                .onReceive(Just(lobbyCode)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.lobbyCode = filtered
                    }
                }
            StyledLobbyButton(command: JoinLobbyCommand(receiver: viewModel,
                                                        lobbyCode: lobbyCode),
                              text: "Join Lobby")
        }
        .padding(20)
    }
}

struct StyledLobbyButton: View {
    var command: ButtonCommand
    var text: String

    var body: some View {
        Button(action: { command.executeAction(inputData: ()) }) {
            Text(text)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(minWidth: 200)
                .background(Color.purple)
                .cornerRadius(20)
                .shadow(radius: 5)
        }

    }
}
