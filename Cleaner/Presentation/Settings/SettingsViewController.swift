//
//  SettingsViewController.swift
//  Cleaner
//
//  Created by Alex on 18.12.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
