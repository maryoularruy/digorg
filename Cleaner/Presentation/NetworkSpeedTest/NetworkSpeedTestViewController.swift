//
//  NetworkSpeedTestViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import UIKit

final class NetworkSpeedTestViewController: UIViewController {
    private lazy var rootView = NetworkSpeedTestView()
    
    override func loadView() {
        super.loadView()
        view = rootView
        
        //
        rootView.backgroundColor = .acidGreen
        //
    }
}
