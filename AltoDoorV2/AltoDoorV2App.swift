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

    var body: some Scene {
        WindowGroup {
                ContentView()
            
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
     FirebaseApp.configure()
     return true
   }
 }
