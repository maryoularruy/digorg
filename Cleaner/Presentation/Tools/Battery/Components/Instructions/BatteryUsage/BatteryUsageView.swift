//
//  BatteryUsageView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class BatteryUsageView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Battery Usage")
        return label
    }()
    
    private lazy var imageView1 = InstructionsImageView(.batteryUsage1, size: CGSize(width: 252, height: 268))
    
    private lazy var instructionsView1 = InstructionView(title: "Battery usage: keep your battery charge under control",
                                                         description: """
To see which apps drain your battery the most, go to Settings and tap Battery. Apps are listed here in order of battery consumption.

Tap View Activity to see how long each app has been in use, or tap View Battery Usage to see battery usage by app.
""")
    
    private lazy var imageView2 = InstructionsImageView(.batteryUsage2, size: CGSize(width: 252, height: 268))
    
    private lazy var instructionsView2 = InstructionView(description: """
You can view records for the last 24 hours or 10 days. This data can help you understand which applications use the most battery power and avoid using those applications when your battery power is low.

Check the battery status to see if it is in good condition. This section shows the maximum capacity of the battery and its performance. If you want to extend the life of your battery, use optimized battery charging, which is enabled by default.
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
        contentView.addSubviews([arrowBack, label, imageView1, instructionsView1, imageView2, instructionsView2])
        
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
            instructionsView2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
