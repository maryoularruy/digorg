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
            "Please enable access to the photo library in Settings"
        case .contacts:
            "Please enable access to the contacts in Settings"
        case .calendar:
            "Please enable access to the calendar in Settings"
        case .camera:
            "Please enable access to the phone camera in Settings"
        }
        
        let alert = UIAlertController(title: "Access Denied", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            self.openAppSettings()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
