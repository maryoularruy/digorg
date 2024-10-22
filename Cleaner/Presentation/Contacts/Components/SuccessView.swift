//
//  SuccessView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 22.10.2024.
//

import UIKit

enum SuccessViewType {
    case successMerge
    
    var text: String {
        switch self {
        case .successMerge: "Merge Completed"
        }
    }
}

final class SuccessView: UIView {
    static var myFrame = CGRect(origin: .zero, size: CGSize(width: 176, height: 182))
    
    private lazy var nibName = "SuccessView"

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var title: Semibold15LabelStyle!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(type: .successMerge)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(type: .successMerge)
    }
    
    private func setup(type: SuccessViewType) {
        Bundle.main.loadNibNamed(nibName, owner: self)
        contentView.layer.cornerRadius = 16
        title.bind(text: type.text)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addShadows()
    }
}
