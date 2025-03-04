//
//  WebViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.03.2025.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, WKUIDelegate {
    private var privacyPolicyURL = URL(string: "https://www.freeprivacypolicy.com/live/710ddc60-8681-4af7-a7ca-f0e239e39bfa")
    private var termsOfUseURL = URL(string: "https://www.freeprivacypolicy.com/live/c030b16a-d726-4911-ad02-8f640274b011")
    
    private lazy var rootView = WebView()
    private var isPrivacyPolicy: Bool
    
    init(isPrivacyPolicy: Bool) {
        self.isPrivacyPolicy = isPrivacyPolicy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.webView.uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let url = isPrivacyPolicy ? privacyPolicyURL : termsOfUseURL else { return }
        rootView.webView.load(URLRequest(url: url))
    }
}
