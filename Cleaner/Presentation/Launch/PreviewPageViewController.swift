//
//  PreviewPageViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.03.2025.
//

import UIKit
import AVFoundation

final class PreviewPageViewController: UIViewController {
    private(set) var videoPath: String
    
    private lazy var playerLayer: AVPlayerLayer = AVPlayerLayer()
    
    init(videoPath: String) {
        self.videoPath = videoPath
        super.init(nibName: nil, bundle: nil)
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initConstraints() {
        playerLayer.videoGravity = .resizeAspect
        let player = AVPlayer(url: URL(fileURLWithPath: videoPath))
        playerLayer.player = player
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        player.play()
    }
}
