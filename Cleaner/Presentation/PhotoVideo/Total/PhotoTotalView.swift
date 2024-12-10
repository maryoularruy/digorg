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
    lazy var progressBar = HorizontalProgressBar()
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
    
    private lazy var contentainerForVisibleOneCategoryViews = UIView()
    
    private lazy var horizontalOneCategoryViews: [OneCategoryProtocol] = [
        similarPhotosView,
        duplicatePhotosView,
        portraitsPhotosView,
        allPhotosView
    ]
    
    private lazy var nonHorizontalOneCategoryViews: [OneCategoryProtocol] = [
        livePhotosView,
        blurryPhotosView,
        screenshotsView,
    ]
    
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
        let container = createNonHorizontalOneCategoryViewsContainer()
        
        var visibleViews: [UIView] = horizontalOneCategoryViews.filter { !$0.assets.isEmpty }
        if let duplicatePhotosViewIndex = visibleViews.firstIndex(where: { $0 == duplicatePhotosView }) {
            visibleViews.insert(container, at: duplicatePhotosViewIndex + 1)
        } else {
            visibleViews.insert(container, at: 0)
        }
        contentainerForVisibleOneCategoryViews.subviews.forEach { $0.removeFromSuperview() }
        contentainerForVisibleOneCategoryViews.addSubviews(visibleViews)

        for (index, subview) in contentainerForVisibleOneCategoryViews.subviews.enumerated() {
            //setup top contsraint
            if index == 0 {
                NSLayoutConstraint.activate([
                    subview.topAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.topAnchor)
                ])
            } else {
                NSLayoutConstraint.activate([
                    subview.topAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.subviews[index - 1].bottomAnchor, constant: 8)
                ])
            }
            
            //setup leading&trailing constraints
            NSLayoutConstraint.activate([
                subview.leadingAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.trailingAnchor)
            ])
            
            //setup bottom constraints
            if index == contentainerForVisibleOneCategoryViews.subviews.count - 1 {
                NSLayoutConstraint.activate([
                    subview.bottomAnchor.constraint(equalTo: contentainerForVisibleOneCategoryViews.bottomAnchor, constant: -8)
                ])
            }
        }
    }
    
    private func createNonHorizontalOneCategoryViewsContainer() -> UIView {
        let containerView = UIView()
        containerView.addSubviews([livePhotosView, blurryPhotosView, screenshotsView])
        
        NSLayoutConstraint.activate([
            livePhotosView.topAnchor.constraint(equalTo: containerView.topAnchor),
            livePhotosView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            livePhotosView.heightAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.height),
            livePhotosView.widthAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.width),
            
            blurryPhotosView.topAnchor.constraint(equalTo: livePhotosView.bottomAnchor, constant: 8),
            blurryPhotosView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurryPhotosView.heightAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.height),
            blurryPhotosView.widthAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.width),
            blurryPhotosView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            screenshotsView.topAnchor.constraint(equalTo: containerView.topAnchor),
            screenshotsView.leadingAnchor.constraint(equalTo: livePhotosView.trailingAnchor, constant: 8),
            screenshotsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            screenshotsView.bottomAnchor.constraint(equalTo: blurryPhotosView.bottomAnchor)
        ])
        
        ([livePhotosView, blurryPhotosView, screenshotsView] as [OneCategoryProtocol]).forEach { $0.isHidden = $0.assets.isEmpty }
        
        return containerView
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
        contentView.addSubviews([arrowBack, label, progressBar, contentainerForVisibleOneCategoryViews])
        
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
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            progressBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 29),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            contentainerForVisibleOneCategoryViews.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 20),
            contentainerForVisibleOneCategoryViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentainerForVisibleOneCategoryViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentainerForVisibleOneCategoryViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
