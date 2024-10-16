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
}
