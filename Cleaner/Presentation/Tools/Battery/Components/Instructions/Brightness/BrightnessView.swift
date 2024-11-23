//
//  BrightnessView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class BrightnessView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Brightness")
        return label
    }()
    
    private lazy var imageView1 = InstructionsImageView(.brightness1, size: CGSize(width: 252, height: 304))
    
    private lazy var instructionsView1 = InstructionView(title: "Brightness: Decrease the brightness of the screen to extend battery life",
                                                         description: """
Displays consume a lot of power. Therefore, reducing the brightness can extend battery life.

To do this, swipe down from the top right corner of the Home screen to open the Control Center and lower the brightness slider to dim the backlight.
""")
    
    private lazy var imageView2 = InstructionsImageView(.brightness2, size: CGSize(width: 252, height: 304))
    
    private lazy var instructionsView2 = InstructionView(description: "You can also reduce the auto-lock time and turn off the screen immediately after you finish all activities on your device. Go to Settings > Display & Brightness > Auto Lock and select a shorter time.")
    
    private lazy var imageView3 = InstructionsImageView(.brightness3, size: CGSize(width: 252, height: 258))
    
    private lazy var instructionsView3 = InstructionView(description: """
Auto Brightness

Apple devices are designed to automatically change the brightness based on the current ambient light. To save your device's battery, this setting is enabled by default: Settings > Accessibility > Text display and size.
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
        backgroundColor = .paleGrey
    }
    
    private func initConstraints() {
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, imageView1, instructionsView1, imageView2, instructionsView2, imageView3, instructionsView3])
        
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
            
            instructionsView2.topAnchor.constraint(equalTo: imageView2.bottomAnchor, constant: 20),
            instructionsView2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            instructionsView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView3.topAnchor.constraint(equalTo: instructionsView2.bottomAnchor, constant: 20),
            imageView3.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            instructionsView3.topAnchor.constraint(equalTo: imageView3.bottomAnchor, constant: 20),
            instructionsView3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            instructionsView3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            instructionsView3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
