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
        listenForTransactions()
        
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
    
    func listenForTransactions() {
        Task {
            for await result in Transaction.updates {
                do {
                    let transaction = try checkVerified(result)
                    // Deliver the purchased content to the user
                    await deliverContent(for: transaction)
                    // Finish the transaction
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified(_, let error):
            throw error
        }
    }

    func deliverContent(for transaction: Transaction) async {
        // Example: Unlock premium features, deliver a subscription, etc.
        print("Delivering content for product \(transaction.productID)")
    }
}
