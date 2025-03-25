//
//  WidgetViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.03.2025.
//

import UIKit

final class WidgetViewController: UIViewController {
    private lazy var rootView = WidgetView()
    
    private lazy var palette: [WidgetBackground] = [
        WidgetBackground(hex: "3585E5", color: .blue, isSelected: true),
        WidgetBackground(hex: "9C60E8", color: .deepPurple, isSelected: false),
        WidgetBackground(hex: "FF971E", color: .deepOrange, isSelected: false),
        WidgetBackground(hex: "F94545", color: .red, isSelected: false),
        WidgetBackground(hex: "F9FAFC", color: .paleGrey, isSelected: false),
        WidgetBackground(hex: "1E1F21", color: .black, isSelected: false),
        WidgetBackground(hex: "2CD747", color: .green, isSelected: false),
        WidgetBackground(hex: "FF68C2", color: .pink, isSelected: false)
    ]
    
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
        palette.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WidgetBackgroundCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.bind(widgetBackground: palette[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        WidgetBackgroundCollectionViewCell.size
    }
}
