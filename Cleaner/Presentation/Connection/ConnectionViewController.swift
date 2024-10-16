//
//  ConnectionViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.10.2023.
//

import UIKit

class ConnectionViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var testStatusLabel: UILabel!
    @IBOutlet weak var wifiInfoView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var connectStatusLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupActions() {
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        wifiInfoView.addTapGestureRecognizer {
            let vc = StoryboardScene.WiFiProtection.initialScene.instantiate()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
        startButton.addTapGestureRecognizer {
            
        }
    }
    
    private func setupUI() {
        
    }
}
