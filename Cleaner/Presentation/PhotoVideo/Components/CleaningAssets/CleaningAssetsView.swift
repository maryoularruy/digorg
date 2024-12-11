//
//  CleaningAssetsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.12.2024.
//

import UIKit

final class CleaningAssetsView: UIView {
    private lazy var progressLabel: Semibold24LabelStyle = Semibold24LabelStyle()
    
    private lazy var cleaningItemsLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.bind(text: "Cleaning unnecessary files....")
        return label
    }()
    
    lazy var progressBar: HorizontalProgressBar = HorizontalProgressBar()
    
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
    
    func startProgress() {
        progressBar.updateProgress(to: 1, duration: 1.4)
    }
    
    func updateProgress() {
        progressLabel.bind(text: "\(progressBar.currentProgress.toPercent())%")
    }
    
    func showCongratsView(deletedItemsCount: Int) {
        subviews.forEach { $0.removeFromSuperview() }
        
        createCongratsView(deletedItemsCount: deletedItemsCount)
    }
    
    private func createCongratsView(deletedItemsCount: Int) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 110, height: 110)))
        imageView.image = .stars
        
        let congratsLabel = Semibold24LabelStyle()
        congratsLabel.bind(text: "Congrats!")
        
        let deletedItemsLabel = UILabel()
        deletedItemsLabel.font = .regular15
        let text = "Deleted \(deletedItemsCount) item\(deletedItemsCount == 1 ? "" : "s")"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.black,
            range: NSRange(location: 0, length: 7)
        )
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.blue,
            range: NSRange(location: 7, length: 7)
        )
        deletedItemsLabel.attributedText = attributedString
        
        addSubviews([imageView, congratsLabel, deletedItemsLabel])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -90),
            
            congratsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            congratsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            deletedItemsLabel.topAnchor.constraint(equalTo: congratsLabel.bottomAnchor, constant: 16),
            deletedItemsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
    }
    
    private func initConstraints() {
        addSubviews([progressLabel, cleaningItemsLabel, progressBar])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            
            cleaningItemsLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 16),
            cleaningItemsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            progressBar.topAnchor.constraint(equalTo: cleaningItemsLabel.bottomAnchor, constant: 16),
            progressBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70)
        ])
    }
}
