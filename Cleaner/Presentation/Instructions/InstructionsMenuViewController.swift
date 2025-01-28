//
//  InstructionsMenuViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class InstructionsMenuViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var instructionsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
}

extension InstructionsMenuViewController: ViewControllerProtocol {
    func setupUI() {
        InstructionCellType.allCases.forEach { type in
            let view = InstructionCell()
            view.delegate = self
            view.bind(type)
            instructionsStackView.addArrangedSubview(view)
        }
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
}

extension InstructionsMenuViewController: InstructionCellDelegate {
    func tapOnCell(_ type: InstructionCellType) {
        let vc: InstructionsViewController = switch type {
        case .safariCache: InstructionsViewController(pages: Pages.SafariCachePage.allCases)
        case .telegramCache: InstructionsViewController(pages: Pages.TelegramCachePage.allCases)
        case .offloadUnusedApps: InstructionsViewController(pages: Pages.OffloadUnusedApps.allCases)
        case .optimizeViberMedia: InstructionsViewController(pages: Pages.OptimizeViberMedia.allCases)
        case .whatsAppCleanup: InstructionsViewController(pages: Pages.WhatsAppCleanup.allCases)
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
}
