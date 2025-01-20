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
        addGestureRecognizers()
    }
    
    deinit {
        print("SecurityQuestionViewController deinit")
    }
}

extension SecurityQuestionViewController: ViewControllerProtocol {
    func setupUI() {}
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.removeTemporaryPasscode()
            self?.popToParentVC()
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
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
