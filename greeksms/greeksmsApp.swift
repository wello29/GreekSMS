//
//  greeksmsApp.swift
//  greeksms
//
//  Created by Tyler Zastrow on 4/6/24.
//

//import SwiftUI
//import FirebaseCore
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}
//
//@main
//struct greeksmsApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject var authViewModel = AuthenticationViewModel()
//
//    var body: some Scene {
//        WindowGroup {
//            if authViewModel.isUserLoggedIn, let user = authViewModel.currentUser {
//                HomePage(authViewModel: authViewModel)
//                    .environmentObject(authViewModel)
//            } else {
//                SignInView()
//                    .environmentObject(authViewModel)
//            }
//        }
//    }
//}
//
//

// greeksmsApp.swift
// greeksms
// Created by Tyler Zastrow on 4/6/24.

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct greeksmsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isUserLoggedIn, let user = authViewModel.currentUser {
                HomePage(authViewModel: authViewModel)
                    .environmentObject(authViewModel)
                    .environmentObject(ContactsViewModel(user: user))
            } else {
                SignInView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
