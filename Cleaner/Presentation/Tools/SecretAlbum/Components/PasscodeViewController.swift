//
//  PasscodeViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 31.10.2024.
//

import UIKit

enum PasscodeMode {
    case create, confirm, enter
    
    var title: String {
        switch self {
        case .create: "Create new Passcode"
        case .confirm: "Confirm Passcode"
        case .enter: "Enter Passcode to unlock"
        }
    }
}

final class PasscodeViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var passcodeLabel: Semibold15LabelStyle!
    
    lazy var passcodeMode: PasscodeMode = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
}

extension PasscodeViewController: ViewControllerProtocol {
    func setupUI() {
        passcodeLabel.bind(text: passcodeMode.title)
    }
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
