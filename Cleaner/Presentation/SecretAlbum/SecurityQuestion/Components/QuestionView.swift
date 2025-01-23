//
//  QuestionView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 21.01.2025.
//

import UIKit

final class QuestionView: UIView {
    private var question: SecurityQuestion
    
    private lazy var questionLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.bind(text: question.question)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var checkImageView = UIImageView(image: .check)
    
    init(question: SecurityQuestion) {
        self.question = question
        super.init(frame: .zero)
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(activeChoice: SecurityQuestion) {
        checkImageView.isHidden = activeChoice != question
    }
    
    private func initConstraints() {
        addSubviews([questionLabel, checkImageView])
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            questionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            checkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            checkImageView.heightAnchor.constraint(equalToConstant: 6),
            checkImageView.widthAnchor.constraint(equalToConstant: 9),
            checkImageView.centerYAnchor.constraint(equalTo: questionLabel.centerYAnchor)
        ])
    }
}
