//
//  PhotoVideoMenuViewController.swift
//  Cleaner
//
//  Created by Alex on 18.12.2023.
//

import UIKit

class PhotoVideoMenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let mediaService = MediaSevice()
    var menuOptions = [
        [
            ("Screenshots", Asset.screenshotsMenu.image),
            ("Similar photos", Asset.similarPhotosMenu.image),
            ("Duplicate photos", Asset.dupPhotosMenu.image),
            ("Photos with text", Asset.photosTextMenu.image),
        ],
        [
            ("Similar videos", Asset.similarVideoMenu.image),
            ("Video compression", Asset.videoCompMenu.image)
        ]
    ]
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: ImageTitleSubtitleTableViewCell.self)
        self.backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension PhotoVideoMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuOptions[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Photos"
        } else {
            return "Videos"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageTitleSubtitleTableViewCell = self.tableView.dequeueReusableCell(for: indexPath)
        cell.titleLabel.text = menuOptions[indexPath.section][indexPath.row].0
        cell.mainImage.image = menuOptions[indexPath.section][indexPath.row].1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            mediaService.loadScreenshotPhotos { assets in
                let vc = StoryboardScene.RegularAssets.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                vc.assets = assets
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            mediaService.loadSimilarPhotos(live: false) { assets in
                let vc = StoryboardScene.GroupedAssets.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                vc.assets = assets
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 0 && indexPath.row == 2 {
            mediaService.loadSimilarPhotos(live: false) { assets in
                let vc = StoryboardScene.GroupedAssets.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                vc.assets = assets
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 0 && indexPath.row == 3 {
            mediaService.getAssetsWithText { assets in
                print("dfsdf", assets.count)
                let vc = StoryboardScene.RegularAssets.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                vc.assets = assets
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            mediaService.loadSimilarVideos { assets in
                let vc = StoryboardScene.GroupedAssets.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                vc.assets = assets
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
