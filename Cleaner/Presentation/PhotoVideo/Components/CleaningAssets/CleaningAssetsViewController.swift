//
//  CleaningAssetsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.12.2024.
//

import UIKit

final class CleaningAssetsViewController: UIViewController {
    private var itemsForDeletion: Int
    private lazy var rootView = CleaningAssetsView()
    private var timer: Timer!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        rootView.startProgress()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showCongratsView()
        }
    }
    
    private func showCongratsView() {
        rootView.showCongratsView(deletedItemsCount: itemsForDeletion)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
    }
}
