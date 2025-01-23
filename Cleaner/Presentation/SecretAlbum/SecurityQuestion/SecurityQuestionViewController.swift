//
//  SecurityQuestionViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.01.2025.
//

import UIKit

enum SecurityQuestionMode {
    case create, enter
}

final class SecurityQuestionViewController: UIViewController {
    var assetsIsParentVC: Bool = true
    
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
        userDefaultsService.set(temporaryPasscode, key: .secretAlbumPasscode)
    }
    
    private func removeTemporaryPasscode() {
        userDefaultsService.remove(key: .temporaryPasscode)
    }
    
    private func saveSecurityQuestion() {
        userDefaultsService.set(rootView.questionMenu.activeChoice.title, key: .securityQuestion)
        userDefaultsService.set(rootView.answerTextField.text, key: .securityQuestionAnswer)
    }
    
    private func popToParentVC() {
        if let vc = navigationController?.viewControllers.first(where: { assetsIsParentVC ? $0 is SecretAssetsViewController : $0 is SecretContactsViewController}) {
            navigationController?.popToViewController(vc, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    deinit {
        print("SecurityQuestionViewController deinit")
    }
}

extension SecurityQuestionViewController: ViewControllerProtocol {
    func setupUI() {
        rootView.questionMenu.delegate = self
        rootView.questionsListView.delegate = self
        rootView.answerTextField.delegate = self
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
            self?.finalTrimTextField()
            self?.savePasscode()
            self?.saveSecurityQuestion()
            self?.removeTemporaryPasscode()
            self?.popToParentVC()
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
