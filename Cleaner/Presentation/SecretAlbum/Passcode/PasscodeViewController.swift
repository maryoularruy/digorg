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
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var firstChar: UIImageView!
    @IBOutlet weak var secondChar: UIImageView!
    @IBOutlet weak var thirdChar: UIImageView!
    @IBOutlet weak var fourthChar: UIImageView!
    @IBOutlet weak var passcodeErrorLabel: Regular13LabelStyle!
    @IBOutlet weak var forgotPasscodeLabel: Regular13LabelStyle!
    
    lazy var passcodeMode: PasscodeMode = .create
    var assetsIsParentVC: Bool = true
    
    private lazy var chars: [UIImageView] = [firstChar, secondChar, thirdChar, fourthChar]
    
    private var passcode: String = ""
    private var tempoparyPasscode: String?
    private lazy var passcodeEntryAttemps: Int = 0
    
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    private func setPasscodeMode(_ mode: PasscodeMode) {
        passcodeMode = mode
        passcodeLabel.bind(text: passcodeMode.title)
    }
    
    private func tapOnForgotPasscode() {
        let vc = SecurityQuestionViewController()
        vc.assetsIsParentVC = assetsIsParentVC
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    deinit {
        print("PasscodeViewController deinit")
    }
}

extension PasscodeViewController: ViewControllerProtocol {
    func setupUI() {
        textField.delegate = self
        textField.becomeFirstResponder()
        passcodeLabel.bind(text: passcodeMode.title)
        passcodeErrorLabel.textColor = .red
        forgotPasscodeLabel.textColor = .blue
        forgotPasscodeLabel.attributedText = "Forgot passcode?".underlined
    }
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        
        forgotPasscodeLabel.addTapGestureRecognizer { [weak self] in
            self?.tapOnForgotPasscode()
        }
    }
}

extension PasscodeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        passcode.removeAll()
        passcode = textField.text ?? ""
        changeCharsImage(count: passcode.count)
    }
    
    private func changeCharsImage(count: Int) {
        if count == 0 {
            chars.forEach { $0.image =  .unfilledCircle}
        } else if count == 1 {
            chars[0].image = .filledCircle
            chars[1].image = .unfilledCircle
            chars[2].image = .unfilledCircle
            chars[3].image = .unfilledCircle
        } else if count == 2 {
            chars[0].image = .filledCircle
            chars[1].image = .filledCircle
            chars[2].image = .unfilledCircle
            chars[3].image = .unfilledCircle
        } else if count == 3 {
            chars[0].image = .filledCircle
            chars[1].image = .filledCircle
            chars[2].image = .filledCircle
            chars[3].image = .unfilledCircle
        } else {
            chars.forEach { $0.image = .filledCircle }
            
            switch passcodeMode {
            case .create:
                saveTempoparyPasscode(passcode)
                refreshTextField()
                setPasscodeMode(.confirm)

            case .confirm:
                if comparePasscodes() {
                    userDefaultsService.set(passcode, key: .temporaryPasscode)
                    let vc = SecurityQuestionViewController()
                    vc.assetsIsParentVC = assetsIsParentVC
                    vc.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    refreshTextField()
                }
                 
            case .enter:
                if passcode == userDefaultsService.get(String.self, key: .secretAlbumPasscode) {
                    userDefaultsService.set(true, key: .isPasscodeConfirmed)
                    navigationController?.popViewController(animated: true)
                } else {
                    passcodeEntryAttemps += 1
                    if passcodeEntryAttemps >= 2 {
                        passcodeErrorLabel.isHidden = true
                        forgotPasscodeLabel.isHidden = false
                    } else {
                        passcodeErrorLabel.isHidden = false
                    }
                    refreshTextField()
                }
            }
        }
    }
    
    private func refreshTextField() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.textField.text?.removeAll()
            self?.chars.forEach { $0.image = .unfilledCircle }
        }
    }
    
    private func saveTempoparyPasscode(_ passcode: String) {
        tempoparyPasscode = passcode
    }
    
    private func comparePasscodes() -> Bool {
        passcode == tempoparyPasscode
    }
}
