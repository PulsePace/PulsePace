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
    @State private var selectedDisruptor = ""

    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.purple)
    }

    var body: some View {
        ZStack {
            if gameVM.selectedGameMode.requires(gameViewElement: .disruptorOptions) {
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
                .padding(20)
                .background(.ultraThinMaterial)
            }
        }
        .onAppear {
            if !gameVM.otherPlayers.isEmpty {
                selectedTarget = gameVM.otherPlayers.randomElement()?.key ??
                    gameVM.otherPlayers[0].key
                selectedDisruptor = gameVM.disruptors.randomElement() ?? "Bomb"
            }
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
            }
        )
    }
}
