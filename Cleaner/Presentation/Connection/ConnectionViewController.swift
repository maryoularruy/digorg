//
//  ConnectionViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.10.2023.
//

import UIKit
import Lottie

class ConnectionViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var testStatusLabel: UILabel!
    @IBOutlet weak var speedAnimationView: LottieAnimationView!
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        GradientService.shared.addGradientBackgroundToButton(button: startButton, colors: [#colorLiteral(red: 0.472941041, green: 0.5231513381, blue: 0.9458861947, alpha: 1), #colorLiteral(red: 0.6934512258, green: 0.5760011077, blue: 0.9499141574, alpha: 1)])
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
