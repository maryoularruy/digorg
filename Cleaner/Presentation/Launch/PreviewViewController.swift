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
    
    private var pageVCs: [PreviewPageViewController] = []
    
    private lazy var store = Store.shared
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        setupPages()
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
    
    private func setupPages() {
        pageVCs = [PreviewPageViewController(videoPath: videoPaths[0]), PreviewPageViewController(videoPath: videoPaths[1])]
        pageVCs.forEach { $0.delegate = self }
    }
    
    private func setupPageController() {
        pageVCs.forEach { $0.setupFrame(frame: rootView.pageController.view.frame) }
        
        rootView.pageController.dataSource = self
        rootView.pageController.delegate = self
        addChild(rootView.pageController)
        
        rootView.pageController.setViewControllers([pageVCs[0]], direction: .forward, animated: true, completion: nil)
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
    
    private func updateUserDefaults() {
        userDefaultsService.set(false, key: .isFirstEntry)
    }
    
    private func updateUI() {
        if userDefaultsService.isSubscriptionActive {
            updateAndClose()
        }
    }
    
    private func updateAndClose() {
        updateUserDefaults()
        navigationController?.popViewController(animated: false)
    }
}

extension PreviewViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PreviewPageViewController,
              let index = videoPaths.firstIndex(of: currentVC.videoPath),
              index > 0 else {
            return nil
        }
        return pageVCs[0]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PreviewPageViewController,
              let index = videoPaths.firstIndex(of: currentVC.videoPath),
              index < videoPaths.count - 1 else {
            return nil
        }
        return pageVCs[1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first as? PreviewPageViewController,
           let index = videoPaths.firstIndex(of: currentVC.videoPath) {
            updateCurrentPage(index: index)
        }
    }
}

extension PreviewViewController: PreviewPageViewControllerDelegate {
    func videoDidEnd(videoPath: String) {
        guard let index = videoPaths.firstIndex(of: videoPath) else { return }
        let isFirst = index == 0
        rootView.pageController.setViewControllers(isFirst ? [pageVCs[1]] : [pageVCs[0]], direction: isFirst ? .forward : .reverse, animated: true, completion: nil)
        updateCurrentPage(index: isFirst ? 1 : 0)
    }
}

extension PreviewViewController: PreviewViewDelegate {
    func tapOnStartSubscriptionButton() {
        Task.init {
            do {
                try await store.purchase()
                updateUI()
            } catch(let error) {
                showAlert(error: error)
            }
        }
    }
    
    func tapOnRestore() {
        do {
            try store.restore() { [weak self] result in
                DispatchQueue.main.async {
                    if result {
                        self?.showAlert(title: "Success", subtitle: "Your subscriptions have been restored")
                    } else {
                        self?.showAlert(title: "Error", subtitle: "Could not restore purchases")
                    }
                }
            }
        } catch(let error) {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(error: error)
            }
        }
    }
    
    func tapOnTermsOfUse() {
        let vc = WebViewController(isPrivacyPolicy: true)
        vc.modalPresentationStyle = .popover
        present(vc, animated: true)
    }
    
    func tapOnClose() {
        updateAndClose()
    }
}
