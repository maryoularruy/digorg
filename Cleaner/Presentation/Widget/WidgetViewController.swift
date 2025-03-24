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
}

extension WidgetViewController: ViewControllerProtocol {
    func setupUI() {
        tabBarController?.tabBar.isHidden = true
        rootView.delegate = self
        rootView.toolbar.delegate = self
        rootView.customSegmentedControl.delegate = self
        rootView.backgroundColorsCollectionView.delegate = self
        rootView.backgroundColorsCollectionView.dataSource = self
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
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

extension WidgetViewController: CustomSegmentedControlDelegate {
    func tapOnButton(index: Int) {
        rootView.changeWigdetPreviews(index: index)
    }
}

extension WidgetViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        
    }
}

extension WidgetViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WidgetBackgroundCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.bind(widgetBackground: WidgetBackground(id: 0, color: .blue, selectedImage: UIImage(resource: .blueSelected), isSelected: false))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        WidgetBackgroundCollectionViewCell.size
    }
}
