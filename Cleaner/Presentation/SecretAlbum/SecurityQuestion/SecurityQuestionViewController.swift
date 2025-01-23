//
//  SecurityQuestionViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.01.2025.
//

import UIKit

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
            var text = self?.rootView.answerTextField.text ?? ""
            text = text.trimLeadingAndTrailingSpaces()
            text = String(text.prefix(30))
            self?.rootView.answerTextField.text = text
            self?.rootView.answerTextFieldCharsCountLabel.bind(text: "\(text.count)/30")
        }
    }
    
    @objc override func handleSwipeRight() {
        removeTemporaryPasscode()
        popToParentVC()
    }
    
    private func removeTemporaryPasscode() {
        userDefaultsService.remove(key: .temporaryPasscode)
    }
    
    private func popToParentVC() {
        if let vc = navigationController?.viewControllers.first(where: { assetsIsParentVC ? $0 is SecretAssetsViewController : $0 is SecretContactsViewController}) {
            navigationController?.popToViewController(vc, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
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
