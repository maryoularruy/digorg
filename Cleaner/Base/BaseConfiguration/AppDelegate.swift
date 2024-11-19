//
//  AppDelegate.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.07.2023.
//

import IQKeyboardManagerSwift
import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        PhoneInfoService.shared.getTotalRam()
        StoriesData.shared.setup()
        
        DispatchQueue.main.async {
//            if Defaults.isOnboardingSeen {
//                let vc = StoryboardScene.Main.initialScene.instantiate()
//                self.window?.rootViewController = vc
//                self.window?.makeKeyAndVisible()
//
//            } else {
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarController") as UITabBarController
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
//            }
        }
        return true
    }
}
