//
//  SecurityQuestionView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.01.2025.
//

import UIKit

final class SecurityQuestionView: UIView {
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var selectQuestionLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.bind(text: "Select security question")
        return label
    }()
    
    private lazy var questionMenu: QuestionMenu = {
        let questionMenu = QuestionMenu(type: .favoriteColor)
        questionMenu.layer.cornerRadius = 20
        questionMenu.delegate = self
        return questionMenu
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        initConstraints()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([arrowBack, selectQuestionLabel, questionMenu])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.5),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            selectQuestionLabel.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 20),
            selectQuestionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            questionMenu.topAnchor.constraint(equalTo: selectQuestionLabel.bottomAnchor, constant: 16),
            questionMenu.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            questionMenu.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            questionMenu.heightAnchor.constraint(equalToConstant: 67)
        ])
    }
}

extension SecurityQuestionView: QuestionMenuDelegate {
    func tapOnQuestionMenu() {
        
    }
}
