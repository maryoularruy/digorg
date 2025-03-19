//
//  WidgetViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.03.2025.
//

import UIKit

final class WidgetViewController: UIViewController {
    private lazy var rootView = WidgetView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        //sender.selectedSegmentIndex        
    }
}

extension WidgetViewController: ViewControllerProtocol {
    func setupUI() {
        tabBarController?.tabBar.isHidden = true
        rootView.delegate = self
        rootView.toolbar.delegate = self
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        rootView.segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
}

extension WidgetViewController: WidgetViewDelegate {
    func tapOnWidgetHelp() {
        let vc = InstructionsViewController(pages: Pages.WidgetAddingHelp.allCases)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension WidgetViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        
    }
}
