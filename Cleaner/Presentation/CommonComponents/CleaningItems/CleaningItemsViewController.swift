//
//  CleaningItemsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.12.2024.
//

import UIKit

final class CleaningItemsViewController: UIViewController {
    private var itemsForDeletion: Int
    private lazy var rootView = CleaningItemsView()
    
    init(itemsForDeleting: Int) {
        self.itemsForDeletion = itemsForDeleting
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
}
