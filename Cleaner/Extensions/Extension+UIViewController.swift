//
//  Extension+UIViewController.swift
//  EmpireVPN
//
//  Created by Александр Пономарёв on 19.09.2020.
//  Copyright © 2020 Anchorfree Inc. All rights reserved.
//

import UIKit
import Foundation
import SwiftyUserDefaults
//import Alertift
import LocalAuthentication

private var aView: UIView?

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

	func showSpinner() {
		aView = UIView(frame: self.view.bounds)
		aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)

        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		ai.center = aView?.center ?? CGPoint(x: 0, y: 0)
		ai.startAnimating()
		aView?.addSubview(ai)
		self.view.addSubview(aView ?? UIView())
	}

	func removeSpinner() {
		aView?.removeFromSuperview()
		aView = nil
	}

	func showAlert(title: String, subtitle: String) {
		let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}
}
extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}
