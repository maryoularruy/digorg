//
//  LocationServicesView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 13.11.2024.
//

import UIKit

final class LocationServicesView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Location Services")
        return label
    }()
    
    private lazy var imageView1 = InstructionsImageView(.locationServices1, size: CGSize(width: 252, height: 214))
    
    private lazy var instructionsView1 = InstructionView(title: "Location services: Restricting the use of location information by applications",
                                                         description: "Many applications may request access to your location. However, not all of them need it on a permanent basis. You can see that an app is using your location when an arrow will be displaved in the status bar in the top of the screen.")
    
    private lazy var imageView2 = InstructionsImageView(.locationServices2, size: CGSize(width: 252, height: 214))
    
    private lazy var instructionsView2 = InstructionView(description: "To see which apps are using your current location and restrict access, go to Settings, select Privacy, then tap Location Services. You can use the toggle switch to disable all location services at once, or you can disable them individually for each app. You can also choose Never to deny the app access to your location or select When using the app to allow the app to use your location when you open it.")
    
    private lazy var imageView3 = InstructionsImageView(.locationServices3, size: CGSize(width: 252, height: 268))
    
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
        contentView.addSubviews([arrowBack, label, imageView1, instructionsView1, imageView2, instructionsView2, imageView3])
        
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
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 16),
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
            imageView3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
