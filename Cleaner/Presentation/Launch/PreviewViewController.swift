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
    
    override func loadView() {
        super.loadView()
        view = rootView
        view.backgroundColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
    }
    
    private func setupPageController() {
        rootView.pageController.dataSource = self
        rootView.pageController.delegate = self
        addChild(rootView.pageController)
        
        let initialVC = PreviewPageViewController(videoPath: videoPaths[0])
        
        rootView.pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        rootView.pageController.didMove(toParent: self)
    }
}

extension PreviewViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PreviewPageViewController,
              let index = videoPaths.firstIndex(of: currentVC.videoPath),
              index > 0 else {
            return nil
        }
        return PreviewPageViewController(videoPath: videoPaths[index - 1])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PreviewPageViewController,
              let index = videoPaths.firstIndex(of: currentVC.videoPath),
              index < videoPaths.count - 1 else {
            return nil
        }
        return PreviewPageViewController(videoPath: videoPaths[index + 1])
    }
}
