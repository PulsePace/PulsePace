//
//  PulsePaceApp.swift
//  PulsePace
//
//  Created by Charisma Kausar on 7/3/23.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase

@main
struct PulsePaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            MenuView()
                .preferredColorScheme(.light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupFirebase()
        return true
    }

    private func setupFirebase() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }
}
