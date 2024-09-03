//
//  WiFiProtectionViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 11.10.2023.
//

import UIKit

class WiFiProtectionViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var wpa3Label: UILabel!
    @IBOutlet weak var wpaLabel: UILabel!
    @IBOutlet weak var wepLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        let attrs = [NSAttributedString.Key.font : FontFamily.SFProDisplay.bold.font(size: 16) ?? UIFont.boldSystemFont(ofSize: 16)]
        let openText = NSMutableAttributedString(string:"Open networks are absolutely unsafe", attributes:attrs)
        openText.append(NSMutableAttributedString(string:", the information sent over them can be overheard by anyone. Keep this in mind when using open networks in public places."))
        openLabel.attributedText =  openText
        
        let wepText = NSMutableAttributedString(string:"Wired Equivalent Privacy is the first standard for protecting Wi-Fi networks, describing both authentication and encryption rules. Despite the name, ")
        wepText.append(NSMutableAttributedString(string:"it cannot provide the proper level of security", attributes:attrs))
        wepText.append(NSMutableAttributedString(string:", since it has many vulnerabilities. A single key is used for both authentication and encryption. Encryption is performed by the simplest operation using a key. By intercepting a sufficient number of packets, an attacker can decrypt it. This is possible even in passive mode in a few hours, and active “hackers“ open WEP protection in minutes."))
        wepLabel.attributedText = wepText
        
        let wpaText = NSMutableAttributedString(string:"WPA authentication algorithms were considered quite reliable in 2003, ")
        wpaText.append(NSMutableAttributedString(string:"now we would recommend using this type of protection with caution.", attributes:attrs))
        wpaLabel.attributedText = wpaText
        
        let wpa3Text = NSMutableAttributedString(string:"WPA3 is the newest Wi-Fi protection standard. It uses a new SAE authentication algorithm ")
        wpa3Text.append(NSMutableAttributedString(string:"that is protected from all known attacks.", attributes:attrs))
        wpa3Label.attributedText = wpa3Text
    }
    
    private func setupActions() {
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
