//
//  AltoDoorV2App.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 27.11.2023.
//

import SwiftUI
import Firebase

@main
struct AltoDoorV2App: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State private var loggedIn = false // Add a state variable to track login status

    @ObservedObject var ViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            LoginView(ViewModel: ViewModel) // Pass the loggedIn state to LoginView
                .preferredColorScheme(.dark) // Set dark mode

        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

