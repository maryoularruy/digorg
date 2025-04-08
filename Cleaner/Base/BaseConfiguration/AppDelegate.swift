//
//  AppDelegate.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.07.2023.
//

import UIKit
import WidgetKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Store.shared.updateListenerTask
        NotificationCenter.default.addObserver(self, selector: #selector(batteryPowerSavingModeDidChange), name: Notification.Name.NSProcessInfoPowerStateDidChange, object: nil)
        return true
    }
    
    @objc func batteryPowerSavingModeDidChange() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
