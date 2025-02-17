//
//  MediaCarouselIncrementalIndicator.swift
//  MediaCarousel
//
//  Created by ZhangAo on 2018/5/17.
//

import UIKit

public enum MediaCarouselIncrementalIndicatorDirection {
    case left, right
}

class MediaCarouselIncrementalIndicator: UIView {

    override open class var layerClass: Swift.AnyClass {
        get { return CAReplicatorLayer.self }
    }
    
    public let direction: MediaCarouselIncrementalIndicatorDirection
    public let refreshBlock: (() -> Void)
    public var isEnabled = true {
        didSet {
            self.isHidden = !self.isEnabled
        }
    }
    
    public let pullDistance: CGFloat = 60
    
    private var replicatorLayer: CAReplicatorLayer!
    private var instanceLayer: CALayer!
    private let maxInstanceCount = 14
    
    fileprivate weak var scrollView: UIScrollView?
    fileprivate let indicatorSize: CGFloat = 30
    fileprivate var progress: Float = 0 {
        didSet {
            self.isHidden = false
            
            if self.progress == 0 {
                self.replicatorLayer.instanceCount = 0
            } else {
                self.replicatorLayer.instanceCount = Int(Float(self.maxInstanceCount) * self.progress)
            }
        }
    }
    
    class func indicator(with direction: MediaCarouselIncrementalIndicatorDirection, refreshBlock: @escaping (() -> Void)) -> MediaCarouselIncrementalIndicator {
        switch direction {
        case .left:
            return MediaCarouselIncrementalLeftIndicator(direction: direction, refreshBlock: refreshBlock)
        case .right:
            return MediaCarouselIncrementalRightIndicator(direction: direction, refreshBlock: refreshBlock)
        }
    }
    
    fileprivate init(direction: MediaCarouselIncrementalIndicatorDirection, refreshBlock: @escaping (() -> Void)) {
        self.direction = direction
        self.refreshBlock = refreshBlock
        
        super.init(frame: .zero)
        
        self.replicatorLayer = self.layer as? CAReplicatorLayer
        self.replicatorLayer.instanceCount = 0
        self.replicatorLayer.instanceDelay = CFTimeInterval(1 / Float(self.maxInstanceCount))
        self.replicatorLayer.instanceColor = UIColor.paleGrey.cgColor
        
        let angle = Float(Double.pi * 2.0) / Float(self.maxInstanceCount)
        self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        
        self.instanceLayer = CALayer()
        self.instanceLayer.backgroundColor = UIColor.paleGrey.cgColor
        self.instanceLayer.opacity = 1.0
        self.replicatorLayer.addSublayer(self.instanceLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateFrame()
        
        let layerWidth: CGFloat = 2.0
        let midX = self.bounds.midX - layerWidth / 2.0
        self.instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 3.0)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.removeObservers()
        
        if let newSuperview = newSuperview {
            if let scrollView = newSuperview as? UIScrollView {
                self.scrollView = scrollView
                self.addObservers(scrollView: scrollView)
            } else {
                fatalError("Superview must be a UIScrollView or its subclass!")
            }
        }
    }
    
    func beginRefreshing() {
        self.replicatorLayer.instanceCount = self.maxInstanceCount

        let rotateAnimationShort = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimationShort.fromValue = 0.0
        rotateAnimationShort.toValue = CGFloat.pi * 2.0
        rotateAnimationShort.duration = 1
        rotateAnimationShort.repeatCount = 1
        rotateAnimationShort.isRemovedOnCompletion = true
        self.replicatorLayer.add(rotateAnimationShort, forKey: "RotateAnimationShort")
        
        let rotateAnimationLong = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimationLong.fromValue = CGFloat.pi * 2.0
        rotateAnimationLong.toValue = CGFloat.pi * 4.0
        rotateAnimationLong.duration = 2
        rotateAnimationLong.beginTime = CACurrentMediaTime() + rotateAnimationShort.duration
        rotateAnimationLong.repeatCount = Float.greatestFiniteMagnitude
        self.replicatorLayer.add(rotateAnimationLong, forKey: "RotateAnimationLong")
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 1
        fadeAnimation.repeatCount = Float.greatestFiniteMagnitude

        self.instanceLayer.add(fadeAnimation, forKey: "FadeAnimation")
        
        self.refreshBlock()
    }
    
    public func endRefreshing() {
        UIView.animate(withDuration: 0.4, animations: {
            self.resetRefreshState()
        }) { (finished) in
            self.replicatorLayer.removeAllAnimations()
            self.instanceLayer.removeAllAnimations()
        }
    }
    
    // MARK: - Subclass hook methods
    
    fileprivate func updateFrame() { fatalError("Subclass must override!") }
    fileprivate func contentOffsetDidChange() { fatalError("Subclass must override!") }
    fileprivate func resetRefreshState() { fatalError("Subclass must override!") }
    
}

// KVO
extension MediaCarouselIncrementalIndicator {
    
    fileprivate static var context = "MediaCarouselIncrementalIndicatorKVOContext"
    fileprivate static let contentOffsetKeyPath = "contentOffset"
    fileprivate static let contentSizeKeyPath = "contentSize"
    
    fileprivate func addObservers(scrollView: UIScrollView) {
        scrollView.addObserver(self, forKeyPath: MediaCarouselIncrementalIndicator.contentSizeKeyPath, options: [.new], context: &MediaCarouselIncrementalIndicator.context)
        scrollView.addObserver(self, forKeyPath: MediaCarouselIncrementalIndicator.contentOffsetKeyPath, options: [.new], context: &MediaCarouselIncrementalIndicator.context)
    }
    
    fileprivate func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: MediaCarouselIncrementalIndicator.contentSizeKeyPath)
        self.superview?.removeObserver(self, forKeyPath: MediaCarouselIncrementalIndicator.contentOffsetKeyPath)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &MediaCarouselIncrementalIndicator.context {
            guard let _ = self.scrollView, self.isEnabled else { return }
            
            if keyPath == MediaCarouselIncrementalIndicator.contentSizeKeyPath {
                self.updateFrame()
            } else if keyPath == MediaCarouselIncrementalIndicator.contentOffsetKeyPath {
                self.contentOffsetDidChange()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

fileprivate class MediaCarouselIncrementalLeftIndicator : MediaCarouselIncrementalIndicator {
    
    override func updateFrame() {
        guard let scrollView = self.superview as? UIScrollView else { return }
        
        self.frame = CGRect(x: (-self.pullDistance - self.indicatorSize) / 2,
                            y: (scrollView.bounds.height - self.indicatorSize) / 2,
                            width: self.indicatorSize, height: self.indicatorSize)
    }
    
    override func contentOffsetDidChange() {
        guard let scrollView = self.scrollView, scrollView.contentOffset.x <= 0 && scrollView.contentInset.left == 0 else { return }
        
        let progress = Float(min(1, abs(scrollView.contentOffset.x) / self.pullDistance))
        
        if !scrollView.isDragging && progress == 1 {
            let originalContentOffsetX = scrollView.contentOffset.x
            scrollView.contentInset.left = self.pullDistance
            scrollView.contentOffset.x = originalContentOffsetX
            
            self.beginRefreshing()
        } else {
            self.progress = progress
        }
    }
    
    override func resetRefreshState() {
        self.scrollView?.contentInset.left = 0
    }
}

fileprivate class MediaCarouselIncrementalRightIndicator : MediaCarouselIncrementalIndicator {
    
    override func updateFrame() {
        guard let scrollView = self.superview as? UIScrollView else { return }
        
        self.frame = CGRect(x: scrollView.contentSize.width + (self.pullDistance - self.indicatorSize) / 2,
                            y: (scrollView.bounds.height - self.indicatorSize) / 2,
                            width: self.indicatorSize, height: self.indicatorSize)
    }
    
    override func contentOffsetDidChange() {
        guard let scrollView = self.scrollView,
            scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.width && scrollView.contentInset.right == 0 else { return }
        
        let progress = Float(min(1, (scrollView.contentOffset.x - (scrollView.contentSize.width - scrollView.bounds.width)) / self.pullDistance))
        
        if !scrollView.isDragging && progress == 1 {
            let originalContentOffsetX = scrollView.contentOffset.x
            scrollView.contentInset.right = self.pullDistance
            scrollView.contentOffset.x = originalContentOffsetX
            
            self.beginRefreshing()
        } else {
            self.progress = progress
        }
    }
    
    override func resetRefreshState() {
        self.scrollView?.contentInset.right = 0
    }
}
