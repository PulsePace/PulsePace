//
//  DisruptorOptionsView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 7/4/23.
//

import SwiftUI

struct DisruptorOptionsView: View {
    @EnvironmentObject var gameVM: GameViewModel

    @State private var selectedTarget = ""
    @State private var selectedDisruptor = "Bomb"

    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .tintColor
    }

    var body: some View {
        ZStack {
            if ModeFactory.getGameModeDetails(gameVM.selectedGameMode.modeName)
                .gameViewElements.contains(where: { $0 == GameViewElement.disruptorOptions }) {
                HStack {
                    Text("Select Target")
                        .font(Fonts.caption)
                    Picker("Target", selection: $selectedTarget.onChange(SelectTargetCommand(receiver: gameVM))) {
                        ForEach(gameVM.otherPlayers, id: \.key) {
                            Text($0.value)
                        }
                    }
                    .pickerStyle(.segmented)
                    Spacer(minLength: 20)
                    Text("Select Disruptor")
                        .font(Fonts.caption)
                    Picker("Disruptor", selection: $selectedDisruptor
                        .onChange(SelectDisruptorCommand(receiver: gameVM))) {
                            ForEach(gameVM.disruptors, id: \.self) {
                                Text($0)
                            }
                    }
                    .pickerStyle(.segmented)
                }
                .frame(height: 50)
                .padding(.all, 20)
            }
        }
        .onAppear {
            selectedTarget = gameVM.otherPlayers[0].key
        }
    }
}

extension Binding {
    func onChange(_ handler: PickerCommand) -> Binding<Value> where Value == String {
        Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler.executeAction(inputData: selection)
            })
    }
}
