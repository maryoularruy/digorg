//
//  TutorialViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 07.10.2023.
//

import UIKit

enum TutorialType {
    case telegram
    case whatsApp
    case viber
    case safari
    case offload
    case delete
    case widgets
    case adBlock
    case battery
}

class TutorialViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    var type: TutorialType?
    var data: [OnboardingModel] = []
    
    var currentPageIndex: Int = 0 {
        didSet {
            if currentPageIndex == data.count - 1 {
                nextButton.setTitle("Close", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: TutorialCell.self)
    }

    private func setupUI() {
        switch type {
        case .telegram:
            data = StoriesData.shared.telegram
            titleLabel.text = "Clear Telegram Cache"
        case .whatsApp:
            data = StoriesData.shared.whatsApp
            titleLabel.text = "Clean Up WhatsApp"
        case .viber:
            data = StoriesData.shared.viber
            titleLabel.text = "Optimize Viber"
        case .safari:
            data = StoriesData.shared.safari
            titleLabel.text = "Clean Safari Cache"
        case .offload:
            data = StoriesData.shared.offload
            titleLabel.text = "Offload Unused Apps"
        case .delete:
            data = StoriesData.shared.delete
            titleLabel.text = "Delete Unused Apps"
        case .widgets:
            data = StoriesData.shared.delete
            titleLabel.text = ""
        case.adBlock:
            data = StoriesData.shared.adblock
            titleLabel.text = "Configure AdsBlocker"
        case .battery:
            data = StoriesData.shared.batteryTutorialData
            titleLabel.text = "Charging Animation"
        default:
            break
        }
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = data.count
    }
    
    private func setupActions() {
//        closeButton.addTapGestureRecognizer {
//            self.dismiss(animated: false)
//        }
        
        nextButton.addTapGestureRecognizer {
            if self.currentPageIndex != self.data.count - 1 {
                self.currentPageIndex += 1
                self.collectionView.scrollToItem(at: IndexPath(item: self.currentPageIndex, section: 0), at: .centeredHorizontally, animated: true)
                self.pageControl.currentPage = self.currentPageIndex
            } else {
                self.dismiss(animated: false)
            }
        }
    }
}

extension TutorialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(for: indexPath) as TutorialCell
        cell.setup(data: data[indexPath.item])
        return cell
    }
}

extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        currentPageIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
