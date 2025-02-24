//
//  SuccessView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 22.10.2024.
//

import UIKit

enum SuccessViewType {
    case successMerge, successDelete
    
    var text: String {
        switch self {
        case .successMerge: "Merge Completed"
        case .successDelete: "Delete Completed"
        }
    }
}

final class SuccessView: UIView {
    static var myFrame = CGRect(origin: .zero, size: CGSize(width: 176, height: 182))
    
    private lazy var nibName = "SuccessView"
    private lazy var type: SuccessViewType = .successMerge

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var title: Semibold15LabelStyle!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(type: SuccessViewType) {
        self.type = type
        title.bind(text: type.text)
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        contentView.layer.cornerRadius = 16
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addShadows()
    }
}
