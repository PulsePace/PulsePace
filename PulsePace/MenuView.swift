//
//  MenuView.swift
//  PulsePace
//
//  Created by Charisma Kausar on 14/3/23.
//

import SwiftUI

struct MenuView: View {
    @StateObject private var propertyStorage = PropertyStorage()
    @StateObject private var achievementManager = AchievementManager()
    @StateObject private var audioManager = AudioManager()
    @StateObject private var beatmapManager = BeatmapManager()
    @StateObject private var userConfigManager = UserConfigManager()
    @StateObject private var gameVM = GameViewModel()
    @StateObject private var beatmapDesignerVM = BeatmapDesignerViewModel()
    @StateObject private var pageList = PageList()

    var body: some View {
        NavigationStack(path: $pageList.pages) {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        StyledIconButton(action: { pageList.navigate(to: Page.achievementsPage) }, icon: "trophy.fill")
                        StyledIconButton(action: { pageList.navigate(to: Page.configPage) }, icon: "gear")
                    }
                    Spacer()
                }
                VStack(spacing: 30) {
                    Image("app-header")
                        .resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 600)
                    StyledMenuButton(page: Page.gameModesPage, text: "Play")
                    StyledMenuButton(page: Page.songSelectPage, text: "Design")
                }
            }
            .navigationDestination(for: Page.self) { page in
                renderDestination(page: page)
            }
        }
        .onAppear {
            achievementManager.registerPropertyStorage(propertyStorage)
        }
        .environmentObject(propertyStorage)
        .environmentObject(achievementManager)
        .environmentObject(audioManager)
        .environmentObject(beatmapManager)
        .environmentObject(userConfigManager)
        .environmentObject(gameVM)
        .environmentObject(beatmapDesignerVM)
        .environmentObject(pageList)
    }

    @ViewBuilder
    private func renderDestination(page: Page) -> some View {
        if page == Page.designPage {
            BeatmapDesignerView()
        } else if page == Page.gameModesPage {
            GameModesView()
        } else if page == Page.lobbyPage {
            LobbyView()
        } else if page == Page.playPage {
            GameView()
        } else if page == Page.configPage {
            ConfigView()
        } else if page == Page.songSelectPage {
            SongSelectView()
        } else if page == Page.achievementsPage {
            AchievementsView()
        } else {
            Text("Error 404 Not Found :(`")
        }
    }
}

struct StyledIconButton: View {
    var action: () -> Void
    var icon: String

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(20)
                .foregroundColor(.purple)
        }
    }
}

struct StyledMenuButton: View {
    @EnvironmentObject var pageList: PageList
    var page: Page
    var text: String
    var isDisabled = false

    var body: some View {
        Button(action: { pageList.navigate(to: page) }) {
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

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
