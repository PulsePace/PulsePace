//
//  CardDisplayable.swift
//  PulsePace
//
//  Created by Charisma Kausar on 30/3/23.
//

protocol CardDisplayable {
    var image: String { get set }
    var category: String { get set }
    var title: String { get set }
    var caption: String { get set }
    var page: Page { get set }
    // Used to retrieve correct mode from ModeFactory
    var metaInfo: String { get }
}
