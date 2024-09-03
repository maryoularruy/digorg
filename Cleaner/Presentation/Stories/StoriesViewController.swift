//
//  StoriesViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 03.10.2023.
//

import UIKit

class StoriesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backView: UIView!
    
    let cards: [CardModel] = [
        CardModel(
            image: Asset.mingcuteSafariFill.image,
            title: "Clean Safari Cache",
            desription: ""
        ),
        CardModel(
            image: Asset.telegramLogos.image,
            title: "Clean Telegram Cache",
            desription: ""
        ),
        CardModel(
            image: Asset.setting2.image,
            title: "Offload Unused Apps",
            desription: ""
        ),
        CardModel(
            image: Asset.basilViberSolid.image,
            title: "Optimize Viber Media",
            desription: ""
        ),
        CardModel(
            image: Asset.whatsAppFill.image,
            title: "Clean up WhatsApp",
            desription: ""
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupCollectionView()
    }
    
    private func setupActions() {
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: CardCell.self)
    }
}

extension StoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(for: indexPath) as CardCell
        cell.setup(data: cards[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StoryboardScene.Tutorial.initialScene.instantiate()
        vc.modalPresentationStyle = .fullScreen
        switch indexPath.row {
        case 0:
            vc.type = .telegram
        case 1:
            vc.type = .whatsApp
        case 2:
            vc.type = .viber
        case 3:
            vc.type = .safari
        case 4:
            vc.type = .offload
        case 5:
            vc.type = .delete
        default:
            vc.type = nil
        }
        self.present(vc, animated: false)
    }
}

extension StoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
}
