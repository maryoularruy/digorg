//
//  TelegramCacheViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 27.01.2025.
//

import UIKit

final class TelegramCacheViewController: UIViewController {
    private lazy var rootView = TelegramCacheView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
}
