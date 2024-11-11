//
//  Extension+UIView.swift
//  XMASS
//
//  Created by Максим Лебедев on 16.11.2022.
//

import UIKit

extension UIView {
    enum AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    typealias Action = (() -> Void)?
    
    var tapGestureRecognizerAction: Action? {
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(
                self,
                &AssociatedObjectKeys.tapGestureRecognizer
            ) as? Action
            return tapGestureRecognizerActionInstance
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedObjectKeys.tapGestureRecognizer,
                    newValue,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
                )
            }
        }
    }
    
    func addShadows(
        color: UIColor = UIColor.shadowColor,
        radius: CGFloat = 4.0,
        opacity: Float = 0.72,
        offset: CGSize = CGSize(width: 2, height: 2)) {
            layer.shadowColor = color.cgColor
            layer.shadowRadius = radius
            layer.shadowOpacity = opacity
            layer.shadowOffset = offset
            self.clipsToBounds = false
        }
    
    func setHidden(completion: @escaping (() -> Void)) {
        alpha = 1
        UIView.animate(withDuration: 0.7, delay: 0.5,
                       options: .curveEaseOut, animations: { [weak self] in
            self?.alpha = 0
        }, completion: { _ in completion() })
    }
    
    func createEmptyState(type: EmptyStateType) -> EmptyStateView {
        let emptyStateView = EmptyStateView(frame: EmptyStateView.myFrame)
        emptyStateView.center = center
        emptyStateView.bind(type: type)
        return emptyStateView
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        }
    }
}
