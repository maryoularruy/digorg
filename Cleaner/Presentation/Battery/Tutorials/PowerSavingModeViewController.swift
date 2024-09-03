//
//  PowerSavingModeViewController.swift
//  Cleaner
//
//  Created by Alex on 19.12.2023.
//

import UIKit

class PowerSavingModeViewController: UIViewController {
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
