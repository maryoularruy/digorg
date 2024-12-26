//
//  DuplicatesTableViewCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.12.2024.
//

import UIKit

final class DuplicatesTableViewCell: UITableViewCell {
    static var identifier = "DuplicatesTableViewCell"
    
    lazy var duplicateNumberLabel: Semibold15LabelStyle = Semibold15LabelStyle()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setupCell() {
        backgroundColor = .yellow
        selectionStyle = .none
    }
    
    private func initConstraints() {
        
    }
}
