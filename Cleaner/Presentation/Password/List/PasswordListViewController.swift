//
//  PasswordListViewController.swift
//  Cleaner
//
//  Created by Alex on 27.12.2023.
//

import UIKit

class PasswordListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var plusImageView: UIView!
    
    var groupedCredentials: [String: [Credential]] = [:]
    var sectionTitles: [String] = []
    var filteredCredentials: [Credential] = []
    var isSelectingMode = false {
        didSet {
            if isSelectingMode {
                deleteLabel.isHidden = false
                backView.isHidden = true
                plusImageView.isHidden = true
            } else {
                deleteLabel.isHidden = true
                backView.isHidden = false
                plusImageView.isHidden = false
            }
        }
    }
    var selectedCredentials: [Credential] = []
    @IBOutlet weak var deleteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        searchBar.delegate = self
        searchBar.setImage(Asset.magnifier.image, for: .search, state: .normal)
        
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        for view in searchBar.subviews.last!.subviews {
                if type(of: view) == NSClassFromString("UISearchBarBackground"){
                    view.alpha = 0.0
                }
        }
        
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        
        self.tableView.register(cellType: TitleSubtitleChevronTableViewCell.self)
        
        plusImageView.addTapGestureRecognizer {
            let vc = StoryboardScene.PasswordCreation.initialScene.instantiate()
            vc.update = {
                self.fillTable()
            }
            self.present(vc, animated: true)
        }
        
        selectLabel.addTapGestureRecognizer {
            self.isSelectingMode.toggle()
            if !self.isSelectingMode {
                self.deselectAllCells()
            }
            self.tableView.reloadData()
        }
        
        deleteLabel.addTapGestureRecognizer {
            self.showDeleteAlert()
//            self.deselectAllCells()
//            DBService.shared.deleteCredentials(self.selectedCredentials)
//            self.selectedCredentials.removeAll()
//            self.fillTable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillTable()
    }
    
    func fillTable() {
        groupedCredentials = DBService.shared.getCredentialsGroupedByFirstLetter()
        sectionTitles = groupedCredentials.keys.sorted()
        filteredCredentials = DBService.shared.getCredentials()
        
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
            self.tableView.performBatchUpdates { }
        }
    }
    
    func showDeleteAlert() {
         let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         alert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Delete Passwords: \(selectedCredentials.count)", style: .destructive) { _ in
             self.deselectAllCells()
             DBService.shared.deleteCredentials(self.selectedCredentials)
             self.selectedCredentials.removeAll()
             self.fillTable()
         }
         alert.addAction(deleteAction)
         present(alert, animated: true, completion: nil)
    }
}

extension PasswordListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        return filteredCredentials.filter { String($0.link.prefix(1)).uppercased() == sectionTitle }.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sectionTitles.count else {
            return nil
        }
        let sectionTitle = sectionTitles[section]
        let credentialsInSection = filteredCredentials.filter { String($0.link.prefix(1)).uppercased() == sectionTitle }

        return credentialsInSection.isEmpty ? nil : sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleSubtitleChevronTableViewCell = self.tableView.dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        
        let sectionTitle = sectionTitles[indexPath.section]
        let credentialsInSection = filteredCredentials.filter { String($0.link.prefix(1)).uppercased() == sectionTitle }
                
        let credential = credentialsInSection[indexPath.row]
        
        if isSelectingMode {
            cell.stackViewLeadingConstraint.constant = 65
            cell.checkLeadingConstraint.constant = 8
        } else {
            cell.stackViewLeadingConstraint.constant = 8
            cell.checkLeadingConstraint.constant = -100
        }
        
        UIView.animate(withDuration: 0.2) {
            cell.layoutIfNeeded()
        }
        if isSelectingMode {
            if cell.isCellSelected {
                cell.checkMarkImageView.image = Asset.selectedCheckBox.image
            } else {
                cell.checkMarkImageView.image = Asset.emptyCheckBox.image
            }
        } else {
            cell.isCellSelected = false
            cell.checkMarkImageView.image = Asset.emptyCheckBox.image
        }
        cell.titleLabel.text = credential.link
        cell.subtitleLabel.text = credential.username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelectingMode {
            if let cell = tableView.cellForRow(at: indexPath) as? TitleSubtitleChevronTableViewCell {
                cell.isCellSelected.toggle()
                
                let sectionTitle = sectionTitles[indexPath.section]
                let credentialsInSection = filteredCredentials.filter { String($0.link.prefix(1)).uppercased() == sectionTitle }
                let selectedCredential = credentialsInSection[indexPath.row]
                
                
                if cell.isCellSelected {
                    cell.checkMarkImageView.image = Asset.selectedCheckBox.image
                    selectedCredentials.append(selectedCredential)
                } else {
                    cell.checkMarkImageView.image = Asset.emptyCheckBox.image
                    if let index = selectedCredentials.firstIndex(of: selectedCredential) {
                        selectedCredentials.remove(at: index)
                    }
                }
            }
        } else {
            let sectionTitle = sectionTitles[indexPath.section]
            let credentialsInSection = filteredCredentials.filter { String($0.link.prefix(1)).uppercased() == sectionTitle }
            let selectedCredential = credentialsInSection[indexPath.row]
            
            let vc = StoryboardScene.DetailedPassword.initialScene.instantiate()
            vc.entity = selectedCredential
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func deselectAllCells() {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }

        for indexPath in visibleIndexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? TitleSubtitleChevronTableViewCell {
                cell.isCellSelected = false
                cell.checkMarkImageView.image = Asset.emptyCheckBox.image
            }
        }
    }
}

extension PasswordListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCredentials = DBService.shared.getCredentials()
        } else {
            filteredCredentials = DBService.shared.getCredentials().filter {
                $0.link.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
