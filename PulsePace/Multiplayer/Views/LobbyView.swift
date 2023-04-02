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
    @Binding var path: [Page]
    let selectedModeName: String

    var body: some View {
        VStack {
            renderLobbyControls()
            renderLobbyPlayers(players: viewModel.lobbyPlayers)
            renderMatchControls()
        }
    }

    @ViewBuilder
    private func renderLobbyControls() -> some View {
        HStack {
            if viewModel.lobby == nil {
                StyledLobbyButton(command: CreateLobbyCommand(modeName: selectedModeName, receiver: viewModel),
                                  text: "Create New Lobby")
                Spacer()
                Text("OR")
                    .foregroundColor(.secondary)
                Spacer()
                TextField("Lobby Code", text: $lobbyCode)
                    .frame(maxWidth: 300)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .onReceive(Just(lobbyCode)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.lobbyCode = filtered
                        }
                    }
                StyledLobbyButton(command: JoinLobbyCommand(receiver: viewModel,
                                                            lobbyCode: lobbyCode, modeName: selectedModeName),
                                  text: "Join Lobby")
            }
        }
        .padding(20)
    }

    @ViewBuilder
    private func renderLobbyPlayers(players: [Player]) -> some View {
        VStack {
            if let lobby = viewModel.lobby {
                Text("Lobby Code: \(lobby.playerCount > 0 ? lobby.lobbyId : "Not Found")")
                    .font(.title)
                List {
                    ForEach(players, id: \.playerId) { player in
                        HStack {
                            Text(player.name)
                            Spacer()
                            Text(player.isReady ? "Ready to Play" : "Not Ready")
                                .fontWeight(.bold)
                                .foregroundColor(player.isReady ? Color.green : Color.gray)
                        }
                    }
                }
            }
        }
        .padding(20)
    }

    @ViewBuilder
    private func renderMatchControls() -> some View {
        if let lobby = viewModel.lobby {
            HStack {
                Spacer()
                StyledLobbyButton(command: StartMatchCommand(receiver: viewModel), text: "Start Match",
                                  isDisabled: !lobby.isEligibleToPlay || !lobby.isUserHost)
            }
            .onChange(of: lobby.lobbyStatus) { status in
                if status == .matchStarted {
                    self.path.append(Page.playPage)
                }
            }
            .padding(20)
        }
    }
}

struct StyledLobbyButton: View {
    var command: ButtonCommand
    var text: String
    var isDisabled = false

    var body: some View {
        Button(action: { command.executeAction(inputData: ()) }) {
            Text(text)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(minWidth: 200)
                .background(isDisabled ? Color.gray : Color.purple)
                .cornerRadius(20)
                .shadow(radius: 5)
        }
        .disabled(isDisabled)
    }
}
