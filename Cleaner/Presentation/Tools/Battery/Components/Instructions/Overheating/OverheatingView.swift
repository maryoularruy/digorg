//
//  OverheatingView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class OverheatingView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Overheating")
        return label
    }()
    
    private lazy var imageView1 = InstructionsImageView(.overheating1, size: CGSize(width: 252, height: 268))
    
    private lazy var instructionsView1 = InstructionView(title: "Overheating: Keeps your device cool and optimizes battery life",
                                                         description: """
The optimal temperature for long and comfortable use of the device is 32° to 95°F (0° to 35°C). Therefore, it is recommended to protect it from direct sunlight. Keep in mind that too low temperatures can temporarily reduce battery life and turn off your device.

Use a phone case that allows some air.
Otherwise, your battery may suffer. If the temperature rises, your device will send you an alert and you will have to wait a while before you can use it again. To reduce latency, turn off your device and take it to a cool place to cool down.
""")
    
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
        backgroundColor = .white
    }
    
    private func initConstraints() {
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, imageView1, instructionsView1])
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
            
            arrowBack.topAnchor.constraint(equalTo: scroll.topAnchor),
            arrowBack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: -16),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 22),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            imageView1.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            imageView1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            instructionsView1.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 20),
            instructionsView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            instructionsView1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            instructionsView1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
