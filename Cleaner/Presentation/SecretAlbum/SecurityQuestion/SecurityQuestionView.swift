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
    
    lazy var questionMenu: QuestionMenu = {
        let questionMenu = QuestionMenu(activeChoice: .favoriteColor)
        questionMenu.layer.cornerRadius = 20
        return questionMenu
    }()
    
    lazy var questionsListView: QuestionsListView = {
        let questionsListView = QuestionsListView(activeChoice: .favoriteColor)
        questionsListView.layer.cornerRadius = 13
        questionsListView.addShadows()
        questionsListView.isHidden = true
        return questionsListView
    }()
    
    lazy var answerTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(resource: .lightGrey).cgColor
        textField.layer.masksToBounds = true
        
        let placeholderText = NSAttributedString(string: "Your answer", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(resource: .middleGrey),
            NSAttributedString.Key.font : UIFont.regular15 as Any
        ])
        textField.attributedPlaceholder = placeholderText
        
        textField.font = .regular15
        textField.textColor = .black
        
        textField.keyboardType = .default
        textField.returnKeyType = .done
        
        return textField
    }()
    
    lazy var passwordMismatchLabel: Regular13LabelStyle = {
        let label = Regular13LabelStyle()
        label.bind(text: "Password mismatch")
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    lazy var answerTextFieldCharsCountLabel: Regular13LabelStyle = {
        let label = Regular13LabelStyle()
        label.bind(text: "0/30")
        return label
    }()
    
    private lazy var tipView: TipView = TipView()
    
    lazy var completeButton: ActionToolbarButtonStyle = {
        let button = ActionToolbarButtonStyle()
        button.bind(text: "Complete")
        button.layer.cornerRadius = 25
        button.isClickable = false
        return button
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
        
        addTapGestureRecognizer { [weak self] in
            self?.questionsListView.isHidden = true
        }
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([arrowBack, selectQuestionLabel, questionMenu, answerTextField, passwordMismatchLabel, answerTextFieldCharsCountLabel, tipView, questionsListView, completeButton])
        
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
            questionMenu.heightAnchor.constraint(equalToConstant: 67),
            
            questionsListView.topAnchor.constraint(equalTo: questionMenu.bottomAnchor, constant: 6),
            questionsListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            questionsListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            answerTextField.topAnchor.constraint(equalTo: questionMenu.bottomAnchor, constant: 28),
            answerTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            answerTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            answerTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordMismatchLabel.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 8),
            passwordMismatchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            answerTextFieldCharsCountLabel.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 8),
            answerTextFieldCharsCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            tipView.topAnchor.constraint(equalTo: answerTextFieldCharsCountLabel.bottomAnchor, constant: 19),
            tipView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tipView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
