//
//  Extension+UIViewController.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 19.09.2020.
//

import UIKit

enum PermissionType {
    case media, contacts, calendar, camera
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

	func showAlert(title: String, subtitle: String) {
		let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		present(alert, animated: true)
	}
    
    func showAlert(error: Error) {
        if let error = error as? StoreError {
            if error.isShowAlert {
                let alert = UIAlertController(title: error.title, message: error.subtitle, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true)
            }
        }
    }
    
    func showAccessDeniedAlert(_ type: PermissionType) {
        let message = switch type {
        case .media:
            "We need access to the photo library"
        case .contacts:
            "We need access to the contacts"
        case .calendar:
            "We need access to the photo calendar"
        case .camera:
            "We need access to the phone camera"
        }
        
        let alert = UIAlertController(title: "Access Denied", message: "\(message). Please go to the settings and allow access, then restart the app", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            self.openAppSettings()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL) { _ in }
            }
        }
    }
}
