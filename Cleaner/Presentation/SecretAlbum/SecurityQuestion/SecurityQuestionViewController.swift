//
//  SecurityQuestionViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.01.2025.
//

import UIKit

final class SecurityQuestionViewController: UIViewController {
    private lazy var rootView = SecurityQuestionView()
    
    override func loadView() {
        super.loadView()
        view = rootView
        
        //
        rootView.backgroundColor = .acidGreen
        //
    }
}
