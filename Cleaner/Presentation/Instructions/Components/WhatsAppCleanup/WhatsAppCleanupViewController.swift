//
//  WhatsAppCleanupViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 27.01.2025.
//

import UIKit

final class WhatsAppCleanupViewController: UIViewController {
    private lazy var rootView = WhatsAppCleanupView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
}

