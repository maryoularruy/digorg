//
//  PhotoTotalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit

final class PhotoTotalView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Photo Cleanup")
        return label
    }()
    
    lazy var similarPhotosView = OneCategoryHorizontalView(.similarPhotos)
    lazy var duplicatePhotosView = OneCategoryHorizontalView(.duplicatePhotos)
    lazy var livePhotosView = OneCategoryRectangularView(.live)
    lazy var blurryPhotosView = OneCategoryRectangularView(.blurry)
    lazy var screenshotsView = OneCategoryVerticalView(.screenshots)
    lazy var portraitsPhotosView = OneCategoryHorizontalView(.portraits)
    lazy var allPhotosView = OneCategoryHorizontalView(.allPhotos)
    
    lazy var allOneCategoryViews: [OneCategoryProtocol] = [
        similarPhotosView,
        duplicatePhotosView,
        livePhotosView,
        blurryPhotosView,
        screenshotsView,
        portraitsPhotosView,
        allPhotosView
    ]
    
    lazy var visibleOneCategoryViews: [OneCategoryProtocol] = []
    private lazy var contentainerForVisibleOneCategoryViews = UIView()
    
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
    
    func constrainVisibleOneCategoryViews() {
        contentainerForVisibleOneCategoryViews.subviews.forEach { $0.removeFromSuperview() }
        
        contentainerForVisibleOneCategoryViews.addSubviews(visibleOneCategoryViews)
        
        for (index, subview) in visibleOneCategoryViews.enumerated() {
            //setup top contsraint
            if index == 0 {
                NSLayoutConstraint.activate([
                    subview.topAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.topAnchor)
                ])
            } else {
                let topConstraint = subview.topAnchor.constraint(equalTo: visibleOneCategoryViews[index - 1].bottomAnchor)
                topConstraint.constant =
                if let type = subview.type as? OneCategory.RectangularViewType {
                    type == .live ? 16 : 8
                } else if let type = subview.type as? OneCategory.VerticalViewType {
                    type == .screenshots ? 16 : 8
                } else if let type = subview.type as? OneCategory.HorizontalViewType {
                    type == .portraits ? 16 : 8
                } else { 8 }
                topConstraint.isActive = true
            }
            
            //setup leading&trailing constraints
            if let type = subview.type as? OneCategory.RectangularViewType {
                NSLayoutConstraint.activate([
                    subview.leadingAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.leadingAnchor),
                    subview.heightAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.height),
                    subview.widthAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.width)
                ])
            } else if let type = subview.type as? OneCategory.VerticalViewType {
                NSLayoutConstraint.activate([
                    subview.trailingAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.trailingAnchor),
                    subview.widthAnchor.constraint(equalToConstant: OneCategoryVerticalView.width)
                ])
                
                if index == visibleOneCategoryViews.count - 1 {
                    NSLayoutConstraint.activate([
                        subview.bottomAnchor.constraint(equalTo: visibleOneCategoryViews[index + 1].topAnchor, constant: -8)
                    ])
                }
            } else {
                NSLayoutConstraint.activate([
                    subview.leadingAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.leadingAnchor),
                    subview.trailingAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.trailingAnchor)
                ])
            }
            
            //setup bottom constraints
            if let lastSubview = visibleOneCategoryViews.last {
                NSLayoutConstraint.activate([
                    lastSubview.bottomAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.bottomAnchor)
                ])
            }
        }
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        if !UserDefaultsService.shared.isSubscriptionActive {
            duplicatePhotosView.setLocked()
        } else {
            duplicatePhotosView.unlock()
        }
    }
    
    private func initConstraints() {
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, contentainerForVisibleOneCategoryViews])
        
        contentainerForVisibleOneCategoryViews.backgroundColor = .acidGreen
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -90),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -16),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            contentainerForVisibleOneCategoryViews.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            contentainerForVisibleOneCategoryViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentainerForVisibleOneCategoryViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentainerForVisibleOneCategoryViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
