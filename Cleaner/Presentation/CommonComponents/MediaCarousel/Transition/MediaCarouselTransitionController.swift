//
//  MediaCarouselTransitionController.swift
//  MediaCarousel
//
//  Created by ZhangAo on 09/09/2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import UIKit

open class MediaCarouselTransitionController: UIPresentationController, UIViewControllerTransitioningDelegate {

    open var gallery: MediaCarousel!
    
    internal var interactiveController: MediaCarouselInteractiveTransition?
    
    init(gallery: MediaCarousel, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        self.gallery = gallery
    }
    
    internal func prepareInteractiveGesture() {
        self.interactiveController = MediaCarouselInteractiveTransition(gallery: self.gallery)
    }
        
    // MARK: - UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimator = MediaCarouselTransitionPresent()
        presentAnimator.gallery = self.gallery
        return presentAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissAnimator = MediaCarouselTransitionDismiss()
        dismissAnimator.gallery = self.gallery
        return dismissAnimator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let interactiveController = self.interactiveController, interactiveController.isInteracting {
            return interactiveController
        } else {
            return nil
        }
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
