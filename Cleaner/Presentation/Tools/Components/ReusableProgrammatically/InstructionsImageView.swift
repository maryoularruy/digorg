//
//  InstructionsImageView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 13.11.2024.
//

import UIKit

final class InstructionsImageView: UIImageView {
    let instructionsImage: UIImage
    let size: CGSize
    
    init(_ image: UIImage, size: CGSize) {
        self.instructionsImage = image
        self.size = size
        super.init(frame: CGRect(origin: .zero, size: size))
        bind(image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ image: UIImage) {
        self.image = image
    }
}
