//
//  semester_project_group9App.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/6/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("Application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
    let providerFactory = AppCheckDebugProviderFactory()
    AppCheck.setAppCheckProviderFactory(providerFactory)
    FirebaseApp.configure()
    return true
  }
}

@main
struct semester_project_group9App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var userID = UserDefaults.standard.string(forKey: "uid")
    var email = UserDefaults.standard.string(forKey: "email")
    var body: some Scene {
        WindowGroup {
            if userID != nil {
                NavigationStack {
                    MainView()
                }
            } else {
                ContentView()
            }
        }
        
    }
}
