//
//  QuestionMenu.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.01.2025.
//

import UIKit

protocol QuestionMenuDelegate: AnyObject {
    func tapOnQuestionMenu()
}

final class QuestionMenu: UIView {
    weak var delegate: QuestionMenuDelegate?
    
    var activeChoice: SecurityQuestion
    
    private lazy var questionLabel: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.numberOfLines = 0
        label.bind(text: activeChoice.title)
        return label
    }()
    
    private lazy var bottomArrow: UIImageView = UIImageView(image: .arrowBottomBlue)
    
    init(activeChoice: SecurityQuestion) {
        self.activeChoice = activeChoice
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(activeChoice: SecurityQuestion) {
        self.activeChoice = activeChoice
        questionLabel.bind(text: activeChoice.title)
    }
    
    private func setupView() {
        backgroundColor = .lightBlue
        
        addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnQuestionMenu()
        }
    }
    
    private func initConstraints() {
        addSubviews([questionLabel, bottomArrow])
        
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: bottomArrow.leadingAnchor, constant: -15),
            questionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bottomArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomArrow.centerYAnchor.constraint(equalTo: questionLabel.centerYAnchor),
            bottomArrow.heightAnchor.constraint(equalToConstant: 20),
            bottomArrow.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
