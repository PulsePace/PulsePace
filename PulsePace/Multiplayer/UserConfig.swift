//
//  UserConfig.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

import UIKit

struct UserConfig {
    var id: String = UIDevice.current.identifierForVendor?.uuidString ?? "default"
}
