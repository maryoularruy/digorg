//
//  AdBlockerViewController.swift
//  Cleaner
//
//  Created by Alex on 18.12.2023.
//

import UIKit

class AdBlockerViewController: UIViewController {
    @IBOutlet weak var configureButton: UIButton!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        tutorialView.addTapGestureRecognizer {
            let vc = StoryboardScene.Tutorial.initialScene.instantiate()
            vc.modalPresentationStyle = .fullScreen
            vc.type = .adBlock
            self.present(vc, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GradientService.shared.addGradientBackgroundToButton(button: configureButton, colors: [#colorLiteral(red: 0.472941041, green: 0.5231513381, blue: 0.9458861947, alpha: 1), #colorLiteral(red: 0.6934512258, green: 0.5760011077, blue: 0.9499141574, alpha: 1)])
    }
}
