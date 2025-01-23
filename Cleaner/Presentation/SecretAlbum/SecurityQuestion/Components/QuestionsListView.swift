//
//  QuestionsListView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.01.2025.
//

import UIKit

protocol QuestionsListViewDelegate: AnyObject {
    func tapOnQuestion(_ question: SecurityQuestion)
}

enum SecurityQuestion: CaseIterable {
    case favoriteColor, petName, characterName
    
    var id: Int {
        switch self {
        case .favoriteColor: 0
        case .petName: 1
        case .characterName: 2
        }
    }
    
    var question: String {
        switch self {
        case .favoriteColor: "What is your favorite color?"
        case .petName: "What's your nickname pet?"
        case .characterName: "What is the name of your favorite childhood character?"
        }
    }
}

final class QuestionsListView: UIView {
    weak var delegate: QuestionsListViewDelegate?
    
    private var activeChoice: SecurityQuestion
    
    private lazy var questionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    
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
        questionsStackView.arrangedSubviews.forEach { subview in
            (subview as? QuestionView)?.bind(activeChoice: activeChoice)
        }
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        fillQuestionsStackView()
    }
    
    private func fillQuestionsStackView() {
        SecurityQuestion.allCases.forEach { question in
            let questionView = QuestionView(question: question)
            questionView.bind(activeChoice: activeChoice)
            questionView.addTapGestureRecognizer { [weak self] in
                self?.delegate?.tapOnQuestion(question)
            }
            
            questionsStackView.addArrangedSubview(questionView)
        }
    }
    
    private func initConstraints() {
        addSubviews([questionsStackView])
        
        NSLayoutConstraint.activate([
            questionsStackView.topAnchor.constraint(equalTo: topAnchor),
            questionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            questionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
