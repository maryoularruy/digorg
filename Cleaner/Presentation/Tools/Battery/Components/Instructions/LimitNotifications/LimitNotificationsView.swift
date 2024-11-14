//
//  LimitNotificationsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class LimitNotificationsView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Limit Notifications")
        return label
    }()
    
    private lazy var imageView1 = InstructionsImageView(.limitNotifications1, size: CGSize(width: 252, height: 304))
    
    private lazy var instructionsView1 = InstructionView(title: "Limit notifications: Disable unnecessary notifications on the lock screen",
                                                         description: """
Notifications are alerts that appear on your lock screen. The more notifications you receive, the more battery power you use.

If you want to turn off notifications, go to Settings > Notifications. You'll see a list of apps that are allowed to send notifications. Tap each app to customize the notifications it sends or turn them off.

Turning off the lock screen option prevents notifications from appearing on the lock screen. You can still receive notifications using your device. They also appear in the notification center, but without cluttering the lock screen.

To change permissions for other apps, tap Notifications at the top left to return to the list. You can't turn off all notifications at once. Each app in the list must be checked individually.
""")
    
    private lazy var imageView2 = InstructionsImageView(.limitNotifications2, size: CGSize(width: 252, height: 304))
    
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
