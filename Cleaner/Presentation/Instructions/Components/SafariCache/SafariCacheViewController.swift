//
//  SafariCacheViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 15.11.2024.
//

import UIKit

final class SafariCacheViewController: UIViewController {
    private lazy var rootView = SafariCacheView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
}
