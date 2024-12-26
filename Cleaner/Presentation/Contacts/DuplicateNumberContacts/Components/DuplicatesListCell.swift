//
//  DuplicatesListCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 26.12.2024.
//

import UIKit
import Contacts

final class DuplicatesListCell: UITableViewCell {
    static var identifier = "DuplicatesListCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        initConstraints()
    }
    
    private func setupCell() {
        
    }
    
    private func initConstraints() {
        
    }
}
