//
//  InstructionsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class InstructionsViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var instructionsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
}

extension InstructionsViewController: ViewControllerProtocol {
    func setupUI() {
        InstructionCellType.allCases.forEach { type in
            let view = BatteryInstructionCell()
            view.delegate = self
//            view.bind(type)
//            batterySaveInstructionsStackView.addArrangedSubview(view)
        }
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension InstructionsViewController: BatteryInstructionCellDelegate {
    func tapOnCell(_ type: BatteryInstructionCellType) {
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        present(vc, animated: true)
    }
}
