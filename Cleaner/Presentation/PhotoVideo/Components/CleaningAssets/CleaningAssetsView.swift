//
//  CleaningAssetsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.12.2024.
//

import UIKit

final class CleaningAssetsView: UIView {
    private lazy var currentProgressLabel: Semibold24LabelStyle = Semibold24LabelStyle()
    
    private lazy var cleaningItemsLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.bind(text: "Cleaning unnecessary files....")
        return label
    }()
    
    private lazy var progressBar: HorizontalProgressBar = HorizontalProgressBar()
    
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
        progressBar.updateProgress(to: 1.0, duration: 1)
    }
    
    func addProgress(_ progress: Float) {
        progressBar.addProgress(CGFloat(progress))
        currentProgressLabel.bind(text: "\(Int(progressBar.currentProgress * 100))%")
    }
    
    func resetProgress() {
        currentProgressLabel.bind(text: "0%")
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
        let deletedItemsText = NSAttributedString(string: "\(deletedItemsCount) file\(deletedItemsCount == 1 ? "" : "s")", attributes: [.foregroundColor: UIColor.blue])
        let deleted = NSMutableAttributedString(string: "Deleted ")
        deleted.append(deletedItemsText)
        deletedItemsLabel.attributedText = deleted
        
        addSubviews([imageView, congratsLabel, deletedItemsLabel])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -80),
            
            congratsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            congratsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            deletedItemsLabel.topAnchor.constraint(equalTo: congratsLabel.bottomAnchor, constant: 16),
            deletedItemsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        progressBar.backgroundView.frame = CGRect(origin: .zero, size: CGSize(width: 213, height: 12))
    }
    
    private func initConstraints() {
        addSubviews([currentProgressLabel, cleaningItemsLabel, progressBar])
        
        NSLayoutConstraint.activate([
            cleaningItemsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cleaningItemsLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            
            currentProgressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentProgressLabel.bottomAnchor.constraint(equalTo: cleaningItemsLabel.topAnchor, constant: -16),
            
            progressBar.topAnchor.constraint(equalTo: cleaningItemsLabel.bottomAnchor, constant: 16),
            progressBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressBar.widthAnchor.constraint(equalToConstant: 213)
        ])
    }
}
