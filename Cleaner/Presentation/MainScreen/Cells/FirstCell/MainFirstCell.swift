//
//  MainFirstCell.swift
//  Cleaner
//
//  Created by Максим Лебедев on 18.10.2023.
//

import UIKit
import Reusable
import Lottie
import GradientProgressBar

class MainFirstCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var progressBar: GradientProgressBar!
    @IBOutlet weak var CalendarView: UIView!
    @IBOutlet weak var contactsView: UIView!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var photoUsedMemory: UILabel!
    @IBOutlet weak var photoItemsLabel: UILabel!
    @IBOutlet weak var duplicatesLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var secondVpnView: UIView!
    @IBOutlet weak var firstVpnView: UIView!
    @IBOutlet weak var vpnButtonStatusLabel: UILabel!
    @IBOutlet weak var vpnButton: LottieAnimationView!
    @IBOutlet weak var choiceLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var usedMemoryView: UIView!
    @IBOutlet weak var connectionIndicatorLabel: UILabel!
    @IBOutlet weak var connectionIndicatorImage: UIImageView!
    @IBOutlet weak var usedMemoryPercentageLabel: UILabel!
    @IBOutlet weak var maxMemoryLabel: UILabel!
    @IBOutlet weak var usedMemoryLabel: UILabel!
    @IBOutlet weak var storiesView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        GradientService.shared.addGradientToView(view: firstVpnView, transform: CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.94, b: 2.39, c: -1.53, d: -3.9, tx: 1.76, ty: 1.76)), colors: [UIColor(red: 0.817, green: 0.788, blue: 0.996, alpha: 1), UIColor(red: 0.658, green: 0.692, blue: 1, alpha: 1)])
        GradientService.shared.addGradientToView(view: secondVpnView, transform: CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.83, b: 1.58, c: -1.24, d: 0.67, tx: 0.84, ty: -0.42)), colors: [UIColor(red: 0.817, green: 0.788, blue: 0.996, alpha: 1), UIColor(red: 0.658, green: 0.692, blue: 1, alpha: 1)])
        GradientService.shared.addGradientToView(view: usedMemoryView, transform: CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.14, b: 2.02, c: -2.02, d: 1.29, tx: 1.51, ty: -0.65)), colors: [UIColor(red: 0.467, green: 0.591, blue: 0.95, alpha: 1), UIColor(red: 0.34, green: 0.401, blue: 0.95, alpha: 1)])
    }
    
    func setupUI() {
        progressBar.setProgress(0.75, animated: true)
        progressBar.gradientColors = [.white, .white]
        progressBar.layer.masksToBounds = true
    }
}
