//
//  ManagingConnectionsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class ManagingConnectionsView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Managing Connections")
        return label
    }()
    
    private lazy var imageView1 = InstructionsImageView(.managingConnections1, size: CGSize(width: 252, height: 268))
    
    private lazy var instructionsView1 = InstructionView(title: "Managing Connections: Turn off your cellular connections to conserve battery life",
                                                         description: """
Battery life is affected by the cellular connection established by your device. Please note that using 3G and 4G in low signal areas will drain the battery quickly.

If you wish to disable cellular data usage, go to Settings, select Cellular and disable cellular data.

A less extreme option is low data mode. To enable it, go to Settings, select Cellular, select Cellular Data Options, and turn on Low Data Mode. This reduces your device's network data usage.

Airplane mode reduces the impact of weak signals on battery life. You can activate it from the Control Center: From the Home screen, swipe down from the top right corner and tap the airplane icon.

Airplane mode is useful when traveling.
Enabling both saves battery power and avoids costly roaming charges.
""")
    
    private lazy var imageView2 = InstructionsImageView(.managingConnections2, size: CGSize(width: 252, height: 268))
    
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
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, imageView1, instructionsView1, imageView2])
        
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
            
            imageView2.topAnchor.constraint(equalTo: instructionsView1.bottomAnchor, constant: 20),
            imageView2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
