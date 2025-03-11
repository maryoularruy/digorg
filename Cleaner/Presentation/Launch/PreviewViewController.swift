//
//  PreviewViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 09.03.2025.
//

import UIKit
import AVFoundation

final class PreviewViewController: UIViewController {
    private lazy var rootView = PreviewView()
    
    private var videoPaths: [String] = [Bundle.main.path(forResource: "DeleteDuplicatePhotos", ofType: "mov") ?? "",
                                        Bundle.main.path(forResource: "MergeDuplicateContacts", ofType: "mov") ?? ""]
    
    private lazy var store = Store.shared
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.bind(price: store.getSubscriptionPrice())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPageController()
        setupPageControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.animateStartSubscriptionButton()
    }
    
    private func setupPageController() {
        rootView.pageController.dataSource = self
        rootView.pageController.delegate = self
        addChild(rootView.pageController)
        
        let initialVC = PreviewPageViewController(videoPath: videoPaths[0])
        initialVC.setupFrame(frame: rootView.pageController.view.frame)
        
        rootView.pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        rootView.pageController.didMove(toParent: self)
    }
    
    private func setupPageControl() {
        rootView.pageControl.isUserInteractionEnabled = false
        rootView.pageControl.numberOfPages = videoPaths.count
        rootView.pageControl.currentPage = 0
        rootView.pageControl.currentPageIndicatorTintColor = .blue
        rootView.pageControl.pageIndicatorTintColor = .lightGrey
    }
    
    private func updateCurrentPage(index: Int) {
        rootView.pageControl.currentPage = index
    }
}

extension PreviewViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PreviewPageViewController,
              let index = videoPaths.firstIndex(of: currentVC.videoPath),
              index > 0 else {
            return nil
        }
        let previousVC = PreviewPageViewController(videoPath: videoPaths[index - 1])
        previousVC.setupFrame(frame: rootView.pageController.view.frame)
        return previousVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PreviewPageViewController,
              let index = videoPaths.firstIndex(of: currentVC.videoPath),
              index < videoPaths.count - 1 else {
            return nil
        }
        let nextVC = PreviewPageViewController(videoPath: videoPaths[index + 1])
        nextVC.setupFrame(frame: rootView.pageController.view.frame)
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first as? PreviewPageViewController,
           let index = videoPaths.firstIndex(of: currentVC.videoPath) {
            updateCurrentPage(index: index)
        }
    }
}
