//
//  AppDelegate.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.07.2023.
//

import IQKeyboardManagerSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        Store.shared.fetchProducts(productIdentifiers: Store.productIds)
        
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarController") as UITabBarController
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        return true
    }
}
