//
//  RoomSetting.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

struct RoomSetting: Codable {
    let minPlayerCount: Int
    let maxPlayerCount: Int
}

final class RoomSettingFactory {
    static let defaultSetting = RoomSetting(minPlayerCount: 1, maxPlayerCount: 1)
    static let baseCoopSetting = RoomSetting(minPlayerCount: 2, maxPlayerCount: 2)
    static let competitiveSetting = RoomSetting(minPlayerCount: 2, maxPlayerCount: 4)
}
