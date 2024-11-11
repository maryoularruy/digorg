//
//  OptimizeBatteryChargingViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.11.2024.
//

import UIKit

enum Pages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree
    
    var title: String {
        switch self {
        case .pageZero: "Open Settings"
        case .pageOne: "Go to Battery"
        case .pageTwo: "Tap Battery Health&Charging"
        case .pageThree: "Enable Optimize Battery Charging"
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero: 0
        case .pageOne: 1
        case .pageTwo: 2
        case .pageThree: 3
        }
    }
}

final class OptimizeBatteryChargingViewController: UIViewController {
    private let rootView = OptimizeBatteryChargingView()
//    private var pageController: UIPageViewController?
    private var pages: [Pages] = Pages.allCases
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
        
//        let initialVC = PageVC(with: pages[0])
        
//        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        rootView.pageController.didMove(toParent: self)
    }
}

extension OptimizeBatteryChargingViewController: ViewControllerProtocol {
    func setupUI() {
        setupPageController()
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

extension OptimizeBatteryChargingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        UIViewController()
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentIndex
    }
}
