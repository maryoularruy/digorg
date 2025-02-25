//
//  AppDelegate.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.07.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Store.shared.updateListenerTask
        return true
    }
}
