//
//  PulsePaceApp.swift
//  PulsePace
//
//  Created by Charisma Kausar on 7/3/23.
//

import SwiftUI

@main
struct PulsePaceApp: App {
    @StateObject var audioManager = AudioManager()

    var body: some Scene {
        WindowGroup {
            GameView()
            BeatmapDesignerView(viewModel: BeatmapDesignerViewModel())
                .environmentObject(audioManager)
        }
    }
}
