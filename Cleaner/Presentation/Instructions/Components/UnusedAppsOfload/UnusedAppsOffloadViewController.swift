//
//  UnusedAppsOffloadViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 27.01.2025.
//

import UIKit

final class UnusedAppsOffloadViewController: UIViewController {
    private lazy var rootView = UnusedAppsOffloadView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
}
