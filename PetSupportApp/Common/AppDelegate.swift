//
//  AppDelegate.swift
//  PetSupportApp
//
//  Created by Jun K on 2021-08-06.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x8256D6)
        UINavigationBar.appearance().tintColor = UIColor(rgb: 0xffffff)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xffffff)]
        UITabBar.appearance().barTintColor = UIColor(rgb: 0xf2f2f2)
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance().clientID = "928739773656-k0sol34fsupreoascsjbo9c1pmceleg4.apps.googleusercontent.com"
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

