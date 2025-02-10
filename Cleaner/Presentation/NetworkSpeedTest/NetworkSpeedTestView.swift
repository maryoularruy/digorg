//
//  NetworkSpeedTestView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import UIKit

enum SpeedTestMode {
    case start, stop, restart
}

enum SpeedTestType {
    case download, ping, completed
    
    var title: String {
        switch self {
        case .download: "Download"
        case .ping: "Ping"
        case .completed: "Completed"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .download: .downloadBlue
        case .ping: .ping
        case .completed: nil
        }
    }
    
    var startValue: String {
        switch self {
        case .download: "0.0 Mbs"
        case .ping: "0 ms"
        case .completed: ""
        }
    }
}

final class NetworkSpeedTestView: UIView {
    lazy var mode: SpeedTestMode = .start
    
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold24LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Speed Test")
        return label
    }()
    
    private lazy var speedTestView = SpeedTestView()
    
    private lazy var speedTestCategoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 17
        [downloadView, pingView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var downloadView: SpeedTestCategoryView = SpeedTestCategoryView(type: .download)
    private lazy var pingView: SpeedTestCategoryView = SpeedTestCategoryView(type: .ping)
    
    lazy var toolbar: ActionToolbar = {
        let toolbar = ActionToolbar()
        toolbar.toolbarButton.bind(text: "Start")
        return toolbar
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
    
    func bind(_ mode: SpeedTestMode) {
        self.mode = mode
        
        switch mode {
        case.start: break
        case .stop:
            speedTestView.reset()
            downloadView.reset()
            pingView.reset()
            toolbar.toolbarButton.bind(text: "Stop")
        case .restart:
            speedTestView.updateData(type: .completed)
            toolbar.toolbarButton.bind(text: "Restart")
        }
    }
    
    func updateData(type: SpeedTestType, value: Double) {
        switch type {
        case .download:
            speedTestView.updateData(value: value, type: .download)
            downloadView.updateData(newValue: value)
        case .ping:
            pingView.updateData(newValue: value)
        case .completed:
            break
        }
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
    }
    
    private func initConstraints() {
        addSubviews([contentView, toolbar])
        contentView.addSubviews([arrowBack, label, speedTestView, speedTestCategoriesStackView])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.5),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            speedTestView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            speedTestView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            speedTestView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            speedTestView.heightAnchor.constraint(equalToConstant: 259),
            
            speedTestCategoriesStackView.topAnchor.constraint(equalTo: speedTestView.bottomAnchor, constant: 24),
            speedTestCategoriesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            speedTestCategoriesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
