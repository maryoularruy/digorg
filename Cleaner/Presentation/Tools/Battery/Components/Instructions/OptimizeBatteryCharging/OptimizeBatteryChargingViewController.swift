//
//  OptimizeBatteryChargingViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.11.2024.
//

import UIKit

final class OptimizeBatteryChargingViewController: UIViewController {
    private let rootView = OptimizeBatteryChargingView()
    private var pages: [Page] = Page.allCases
    private var currentIndex: Int = 0
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
        setupUI()
    }
    
    private func setupPageController() {
        rootView.pageController.dataSource = self
        rootView.pageController.delegate = self
        addChild(rootView.pageController)
        
        let initialVC = PageViewConroller(with: pages[0])
        
        rootView.pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        rootView.pageController.didMove(toParent: self)
    }
    
    private func setupPageControl() {
        if let pageControl = (rootView.pageController.view.subviews.first { $0 is UIPageControl }) as? UIPageControl {
            pageControl.currentPageIndicatorTintColor = .blue
            pageControl.pageIndicatorTintColor = .lightGrey
        }
    }
}

extension OptimizeBatteryChargingViewController: ViewControllerProtocol {
    func setupUI() {
        setupPageController()
        rootView.actionButton.bind(text: "\(currentIndex == pages.count - 1 ? "Close" : "Next")")
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

extension OptimizeBatteryChargingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PageViewConroller else { return nil }
        var index = currentVC.page.index
        if index == 0 { return nil }
        
        index -= 1
        return PageViewConroller(with: pages[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PageViewConroller else { return nil }
        var index = currentVC.page.index
        if index >= pages.count - 1 { return nil }
        
        index += 1
        return PageViewConroller(with: pages[index])
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl()
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        rootView.actionButton.bind(text: "\((pendingViewControllers.first as? PageViewConroller)?.page.index == pages.count - 1 ? "Close" : "Next")")
    }
}
