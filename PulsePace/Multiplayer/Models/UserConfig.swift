//
//  UserConfig.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

import UIKit

struct UserConfig: Codable {
    static let randomNameLength = 10
    let userId: String
    let name: String

    init() {
        userId = UIDevice.current.identifierForVendor?.uuidString ?? "default"
        name = UserConfig.getRandomName()
    }

    static func getRandomName() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 0..<UserConfig.randomNameLength {
            let randomIndex = Int(arc4random_uniform(UInt32(letters.count)))
            let randomLetter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString += String(randomLetter)
        }
        return randomString
    }
}

final class UserConfigManager: ObservableObject {
    @Published var userConfig: UserConfig
    let localConfigStorage = "userConfig.json"
    let userConfigDataManager: LocalDataManager<UserConfig>

    init() {
        let userConfigDataManager = LocalDataManager<UserConfig>()
        let fallbackUserConfig = UserConfig()
        self.userConfigDataManager = userConfigDataManager
        self.userConfig = fallbackUserConfig
        userConfigDataManager.load(filename: localConfigStorage, bundlePath: nil,
                                   initData: fallbackUserConfig) { [weak self] result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let userConfig):
                self?.userConfig = userConfig
            }
        }
    }

    func save(_ userConfig: UserConfig) {
        userConfigDataManager.save(values: userConfig, filename: localConfigStorage) {
            result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
}
