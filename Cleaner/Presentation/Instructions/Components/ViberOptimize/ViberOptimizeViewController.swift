//
//  ViberOptimizeViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 27.01.2025.
//

import UIKit

final class ViberOptimizeViewController: UIViewController {
    private lazy var rootView = ViberOptimizeView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
}

