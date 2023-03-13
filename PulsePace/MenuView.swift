//
//  MenuView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 14/3/23.
//

import SwiftUI

struct MenuView: View {
    @StateObject var audioManager = AudioManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("PulsePace")
                    .font(.largeTitle)

                NavigationLink(destination: GameView()) {
                    Text("Gameplay")
                }

                NavigationLink(destination: BeatmapDesignerView(viewModel: BeatmapDesignerViewModel())
                    .environmentObject(audioManager)) {
                        Text("BeatmapDesigner")
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
