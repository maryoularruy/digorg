//
//  OptimizeBatteryChargingViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.11.2024.
//

import UIKit

final class OptimizeBatteryChargingViewController: UIViewController {
    private lazy var rootView = OptimizeBatteryChargingView()
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
        rootView.pageControl.isUserInteractionEnabled = false
        rootView.pageControl.numberOfPages = pages.count
        rootView.pageControl.currentPage = 0
        rootView.pageControl.currentPageIndicatorTintColor = .blue
        rootView.pageControl.pageIndicatorTintColor = .lightGrey
    }
    
    private func updateCurrentPage(index: Int) {
        rootView.pageControl.currentPage = index
    }
    
    private func setupActionButton() {
        rootView.actionButton.bind(text: "\((rootView.pageController.viewControllers?.first as? PageViewConroller)?.page.index == pages.count - 1 ? "Close" : "Next")")
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
        
        rootView.actionButton.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            guard let currentVC = rootView.pageController.viewControllers?.first as? PageViewConroller  else { return }
             
            if currentVC.page.index == pages.count - 1 {
                dismiss(animated: true)
            } else {
                rootView.pageController.setViewControllers([PageViewConroller(with: pages[currentVC.page.index + 1])], direction: .forward, animated: true, completion: nil)
                setupActionButton()
                updateCurrentPage(index: currentVC.page.index + 1)
            }
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first as? PageViewConroller {
            setupActionButton()
            updateCurrentPage(index: currentVC.page.index)
        }
    }
}
