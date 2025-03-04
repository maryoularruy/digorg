//
//  WebView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.03.2025.
//

import UIKit
import WebKit

final class WebView: UIView {
    let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initConstraints()
    }
    
    private func initConstraints() {
        addSubviews([webView])
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
