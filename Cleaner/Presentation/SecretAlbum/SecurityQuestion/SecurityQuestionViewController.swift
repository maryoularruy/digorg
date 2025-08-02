//
//  SecurityQuestionViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.01.2025.
//

import UIKit

enum SecurityQuestionType {
    case create, enter, change
}

final class SecurityQuestionViewController: UIViewController {
    var assetsIsParentVC: Bool = true
    var type: SecurityQuestionType = .create
    
    private lazy var rootView = SecurityQuestionView()
    
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    private func finalTrimTextField() {
        var text = rootView.answerTextField.text ?? ""
        text = text.trimLeadingAndTrailingSpaces()
        text = String(text.prefix(30))
        rootView.answerTextField.text = text
        rootView.answerTextFieldCharsCountLabel.bind(text: "\(text.count)/30")
    }
    
    private func savePasscode() {
        let temporaryPasscode = userDefaultsService.get(String.self, key: .temporaryPasscode)
        userDefaultsService.set(temporaryPasscode, key: .secureVaultPasscode)
    }
    
    private func removePasscode() {
        userDefaultsService.remove(key: .secureVaultPasscode)
    }
    
    private func removeTemporaryPasscode() {
        userDefaultsService.remove(key: .temporaryPasscode)
    }
    
    private func saveSecurityQuestion() {
        userDefaultsService.set(rootView.questionMenu.activeChoice.id, key: .securityQuestionId)
        userDefaultsService.set(rootView.answerTextField.text, key: .securityQuestionAnswer)
    }
    
    private func removeSecurityQuestion() {
        userDefaultsService.remove(key: .securityQuestionId)
        userDefaultsService.remove(key: .securityQuestionAnswer)
    }
    
    private func openPasscodeVC() {
        let vc = StoryboardScene.Passcode.initialScene.instantiate()
        vc.passcodeMode = .create
        vc.assetsIsParentVC = assetsIsParentVC
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func popToParentVC() {
        if type == .change {
            navigationController?.popViewController(animated: true)
        } else {
            if let vc = navigationController?.viewControllers.first(where: { assetsIsParentVC ? $0 is SecretAssetsViewController : $0 is SecretContactsViewController}) {
                navigationController?.popToViewController(vc, animated: true)
            } else {
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

extension SecurityQuestionViewController: ViewControllerProtocol {
    func setupUI() {
        rootView.questionMenu.delegate = self
        rootView.questionsListView.delegate = self
        rootView.answerTextField.delegate = self
        
        if type == .change {
            if userDefaultsService.get(Int.self, key: .securityQuestionId) == nil &&
                userDefaultsService.get(String.self, key: .securityQuestionAnswer) == nil {
                rootView.selectQuestionLabel.bind(text: "Select new security question")
            }
        }
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.removeTemporaryPasscode()
            self?.popToParentVC()
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        
        rootView.completeButton.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            
            if rootView.answerTextField.text == nil || rootView.answerTextField.text?.isEmpty == true {
                return
            }
            
            finalTrimTextField()
            
            switch type {
            case .create:
                savePasscode()
                saveSecurityQuestion()
                removeTemporaryPasscode()
                popToParentVC()
                
            case .enter:
                if rootView.questionMenu.activeChoice.id == userDefaultsService.get(Int.self, key: .securityQuestionId) &&
                    rootView.answerTextField.text == userDefaultsService.get(String.self, key: .securityQuestionAnswer) {
                    removePasscode()
                    removeSecurityQuestion()
                    openPasscodeVC()
                } else {
                    rootView.passwordMismatchLabel.isHidden = false
                }
                
            case .change:
                if userDefaultsService.get(Int.self, key: .securityQuestionId) == nil &&
                    userDefaultsService.get(String.self, key: .securityQuestionAnswer) == nil {
                    saveSecurityQuestion()
                    popToParentVC()

                } else {
                    if rootView.questionMenu.activeChoice.id == userDefaultsService.get(Int.self, key: .securityQuestionId) &&
                        rootView.answerTextField.text == userDefaultsService.get(String.self, key: .securityQuestionAnswer) {
                        removeSecurityQuestion()
                        rootView.selectQuestionLabel.bind(text: "Select new security question")
                        rootView.questionMenu.bind(activeChoice: .favoriteColor)
                        rootView.answerTextField.text = ""
                        rootView.passwordMismatchLabel.isHidden = true
                    } else {
                        rootView.passwordMismatchLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    @objc override func handleSwipeRight() {
        removeTemporaryPasscode()
        popToParentVC()
    }
}

extension SecurityQuestionViewController: QuestionMenuDelegate {
    func tapOnQuestionMenu() {
        rootView.questionsListView.isHidden = !rootView.questionsListView.isHidden
        rootView.answerTextField.resignFirstResponder()
    }
}

extension SecurityQuestionViewController: QuestionsListViewDelegate {
    func tapOnQuestion(_ question: SecurityQuestion) {
        rootView.questionMenu.bind(activeChoice: question)
        rootView.questionsListView.bind(activeChoice: question)
        rootView.questionsListView.isHidden = true
        rootView.layoutIfNeeded()
    }
}

extension SecurityQuestionViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var text = textField.text ?? ""
        text = text.trimLeadingSpaces()
        textField.text = String(text.prefix(30))
        rootView.completeButton.isClickable = !text.isEmpty
        rootView.answerTextFieldCharsCountLabel.bind(text: "\(text.count)/30")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
