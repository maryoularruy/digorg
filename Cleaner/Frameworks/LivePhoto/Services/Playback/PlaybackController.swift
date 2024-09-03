import AVFoundation
import Combine
import UIKit

/// Manages playback for assets.
class PlaybackController {

	let player: AVPlayer
	
	@Published var asset: AVAsset? {
		didSet {
			player.replaceCurrentItem(with: asset.map(AVPlayerItem.init))
		}
	}

	@Published private(set) var isPlaying = false
	@Published private(set) var duration = CMTime.zero

	private let audioSession: AVAudioSession = .sharedInstance()
	private let notificationCenter: NotificationCenter = .default

	init(player: AVPlayer = .init()) {
		self.player = player
		configureAudioSession()
	}

	func play() {
		guard !isPlaying else { return }
		NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
			self.player.seek(to: CMTime.zero)
			self.player.play()
		}
		player.play()
		isPlaying = true
	}

	@objc func pause() {
		guard isPlaying else { return }
		player.pause()
		
		isPlaying = false
	}

	
	
	private func configureAudioSession() {
		try? audioSession.setCategory(.playback)
		notificationCenter.addObserver(self, selector: #selector(pause), name: UIApplication.didEnterBackgroundNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(updateAudioSession), name: AVAudioSession.silenceSecondaryAudioHintNotification, object: audioSession)
		notificationCenter.addObserver(self, selector: #selector(updateAudioSession), name: UIApplication.willResignActiveNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(updateAudioSession), name: UIApplication.didBecomeActiveNotification, object: nil)
		updateAudioSession()
	}

	@objc private func updateAudioSession() {
		player.isMuted = audioSession.secondaryAudioShouldBeSilencedHint
	}
}
