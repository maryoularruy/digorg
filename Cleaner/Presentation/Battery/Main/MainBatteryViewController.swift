//
//  MainBatteryViewController.swift
//  Cleaner
//
//  Created by Alex on 19.12.2023.
//

import UIKit

class MainBatteryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tutorialImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(cellType: BatteryFirstCollectionViewCell.self)
        collectionView.register(cellType: BatterySecondCollectionViewCell.self)
        
        tutorialImageView.addTapGestureRecognizer {
            let vc = StoryboardScene.Tutorial.initialScene.instantiate()
            vc.modalPresentationStyle = .fullScreen
            vc.type = .battery
            self.present(vc, animated: false)
        }
        
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MainBatteryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell: BatteryFirstCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        } else {
            let cell: BatterySecondCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onTap = { vc in
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}
