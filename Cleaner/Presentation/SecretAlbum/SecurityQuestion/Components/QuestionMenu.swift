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

enum SecurityQuestionType {
    case favoriteColor, petName, characterName
    
    var title: String {
        switch self {
        case .favoriteColor: "What is your favorite color?"
        case .petName: "What's your nickname pet?"
        case .characterName: "What is the name of your favorite childhood character?"
        }
    }
}

final class QuestionMenu: UIView {
    weak var delegate: QuestionMenuDelegate?
    private var type: SecurityQuestionType
    
    private lazy var questionLabel: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: type.title)
        return label
    }()
    
    private lazy var bottomArrow: UIImageView = UIImageView(image: .arrowBottomBlue)
    
    init(type: SecurityQuestionType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ type: SecurityQuestionType) {
        questionLabel.bind(text: type.title)
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
            questionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bottomArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomArrow.centerYAnchor.constraint(equalTo: questionLabel.centerYAnchor),
            bottomArrow.heightAnchor.constraint(equalToConstant: 20),
            bottomArrow.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
