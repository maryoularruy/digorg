//
//  Extension+UIViewController.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 19.09.2020.
//

import UIKit

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
}
