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
    private var player: AVPlayer?
    private var playerLooper: AVPlayerLooper?
    
    init(videoPath: String) {
        self.videoPath = videoPath
        super.init(nibName: nil, bundle: nil)
        
        playerLayer.videoGravity = .resizeAspectFill
        
        let item = AVPlayerItem(url: URL(fileURLWithPath: videoPath))
        player = AVQueuePlayer()
        playerLooper = AVPlayerLooper(player: player! as! AVQueuePlayer, templateItem: item)
        playerLayer.player = player
        view.layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    func setupFrame(frame: CGRect) {
        playerLayer.frame = frame
    }
}
