//
//  MenuView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 14/3/23.
//

import SwiftUI

struct MenuView: View {
    @StateObject var audioManager = AudioManager()
    @StateObject var gameVM = GameViewModel()
    @State private var path: [Page] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 30) {
                Text("PulsePace")
                    .font(.largeTitle)

                StyledMenuButton(path: $path, page: Page.gameModesPage, text: "Play")

                StyledMenuButton(path: $path, page: Page.designPage, text: "Design")
            }
            .navigationDestination(for: Page.self) { page in
                if page == Page.designPage {
                    BeatmapDesignerView(path: $path)
                } else if page == Page.gameModesPage {
                    GameModesView(path: $path)
                } else if page == Page.playPage {
                    GameView()
                } else {
                    EmptyView()
                }
            }
        }
        .environmentObject(audioManager)
        .environmentObject(gameVM)
    }
}

struct StyledMenuButton: View {
    @Binding var path: [Page]
    var page: Page
    var text: String

    var body: some View {
        Button(action: { path.append(page) }) {
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

struct Page: Hashable {
    static let designPage = Page(name: "design")
    static let gameModesPage = Page(name: "gameModes")
    static let lobbyPage = Page(name: "lobby")
    static let playPage = Page(name: "play")
    let name: String
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
