//
//  PreviewPageViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.03.2025.
//

import UIKit
import AVFoundation

protocol PreviewPageViewControllerDelegate: AnyObject {
    func videoDidEnd(videoPath: String)
}

final class PreviewPageViewController: UIViewController {
    weak var delegate: PreviewPageViewControllerDelegate?
    
    private(set) var videoPath: String
    
    private lazy var playerLayer: AVPlayerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    private var playerLooper: AVPlayerLooper?
    
    init(videoPath: String) {
        self.videoPath = videoPath
        super.init(nibName: nil, bundle: nil)
        
        playerLayer.videoGravity = .resizeAspectFill
        
        let item = AVPlayerItem(url: URL(fileURLWithPath: videoPath))
        player = AVPlayer(playerItem: item)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: item)
        
        playerLayer.player = player
        view.layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    func setupFrame(frame: CGRect) {
        playerLayer.frame = frame
    }
    
    @objc func videoDidEnd() {
        delegate?.videoDidEnd(videoPath: videoPath)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
