//
//  PathStorage.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/12.
//

import Foundation

class PageList: ObservableObject {
    @Published var pages: [Page]

    init(pages: [Page] = []) {
        self.pages = pages
    }

    func navigate(to page: Page) {
        pages.append(page)
    }

    func backtrack() {
        _ = pages.popLast()
    }
}

struct Page: Hashable {
    static let designPage = Page(name: "design")
    static let gameModesPage = Page(name: "gameModes")
    static let lobbyPage = Page(name: "lobby")
    static let playPage = Page(name: "play")
    static let songSelectPage = Page(name: "songSelect")
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
