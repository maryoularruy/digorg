//
//  BatterySecondCollectionViewCell.swift
//  Cleaner
//
//  Created by Alex on 19.12.2023.
//

import Reusable
import UIKit

class BatterySecondCollectionViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var tableView: UITableView!
    var dataForTable = [
        ("Power Saving Mode", Asset.fi7171736.image),
        ("Cellular communication and\ndata transmission", Asset.fi1011411.image),
        ("iPhone Cooling", Asset.fi4666810.image),
        ("Geolocation Services", Asset.fi8765292.image),
        ("Notifications", Asset.fi1827425.image),
        ("Battery Usage", Asset.fi3103384.image),
        ("Automatic Updates", Asset.fi4391389.image),
        ("Brightness", Asset.fi3856888.image),
        ("Wi-Fi Update", Asset.fi159599.image),
    ]
    
    var storyboards = [
        StoryboardScene.Tutorials.powerSaving.instantiate(),
        StoryboardScene.Tutorials.cellularCommunication.instantiate(),
        StoryboardScene.Tutorials.iPhoneCooling.instantiate(),
        StoryboardScene.Tutorials.geolocationServices.instantiate(),
        StoryboardScene.Tutorials.notifications.instantiate(),
        StoryboardScene.Tutorials.batteryUsage.instantiate(),
        StoryboardScene.Tutorials.automaticUpdates.instantiate(),
        StoryboardScene.Tutorials.brightness.instantiate(),
        StoryboardScene.Tutorials.wiFiUpdate.instantiate(),
    ]
    
    var onTap: ((UIViewController) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(cellType: ImageTitleTableViewCell.self)
    }

}

extension BatterySecondCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageTitleTableViewCell = self.tableView.dequeueReusableCell(for: indexPath)
        cell.titleLabel.text = dataForTable[indexPath.item].0
        cell.mainImageView.image = dataForTable[indexPath.item].1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboards[indexPath.item]
        onTap?(vc)
    }
}
