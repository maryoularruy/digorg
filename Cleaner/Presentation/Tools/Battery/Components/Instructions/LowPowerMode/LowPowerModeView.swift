//
//  LowPowerModeView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 13.11.2024.
//

import UIKit

final class LowPowerModeView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Low Power Mode")
        return label
    }()
    
    private lazy var imageView1 = InstructionsImageView(.lowPowerMode1, size: CGSize(width: 252, height: 214))
    
    private lazy var instructionsView1 = InstructionView(title: "Low Power Mode: Save your battery and extend its life",
                                                         description: """
You can use the smart features of iOS to extend the life of your battery with Low Power Mode. Stop the battery draining process and extend the life of your device.

Low Power Mode saves battery life by disabling features such as background app updates, automatic downloads, and automatic email retrieval. It also temporarily restricts the selection of certain iOS visual effects.

Unlike airplane mode, power-saving mode doesn't affect normal device usage much. Wi-Fi, Bluetooth and cellular connectivity are still available.

By default, when your battery drops to 20%, you'll usually see an iOS notification suggesting you activate Low Power Mode. You'll get another notification when your battery reaches 10%. When power saving mode is enabled, it will automatically turn off once your battery reaches 80% charge.

You can manually activate this mode without waiting for the notification (Settings > Battery).
For faster access, add this feature to your control center. Go to Settings > Control Center and tap the + next to Power Save Mode.

You'll know Battery Saver Mode is active when the battery icon in the upper right corner of the screen turns yellow.
""")
    
    private lazy var imageView2 = InstructionsImageView(.lowPowerMode2, size: CGSize(width: 252, height: 214))
    
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
        contentView.addSubviews([arrowBack, label, imageView1, instructionsView1, imageView2])
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 16),
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
