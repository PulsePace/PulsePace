//
//  MenuView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 14/3/23.
//

import SwiftUI

struct MenuView: View {
    @StateObject var achievementManager = AchievementManager()
    @StateObject var audioManager = AudioManager()
    @StateObject var gameVM = GameViewModel()
    @StateObject var beatmapManager = BeatmapManager()
    @State private var path: [Page] = []
    @State private var modeName = ModeFactory.defaultMode.modeName

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
                    GameModesView(path: $path, modeName: $modeName)
                } else if page == Page.lobbyPage {
                    LobbyView(path: $path, selectedModeName: modeName)
                } else if page == Page.playPage {
                    GameView()
                } else {
                    Text("Error 404 Not Found :(`")
                }
            }
        }
        .environmentObject(achievementManager)
        .environmentObject(audioManager)
        .environmentObject(gameVM)
        .environmentObject(beatmapManager)
    }
}

struct StyledMenuButton: View {
    @Binding var path: [Page]
    var page: Page
    var text: String
    var isDisabled = false

    var body: some View {
        Button(action: { path.append(page) }) {
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

struct Page: Hashable {
    static let designPage = Page(name: "design")
    static let gameModesPage = Page(name: "gameModes")
    static let lobbyPage = Page(name: "lobby")
    static let playPage = Page(name: "play")
    let name: String
    // Data from the page, e.g. gameModesPage contains selected gamemode that should be accessed by lobby page
    var data: Data?

    init(name: String, data: Data? = nil) {
        self.name = name
        self.data = data
    }

    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
