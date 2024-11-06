//
//  DetailedPasswordViewController.swift
//  Cleaner
//
//  Created by Alex on 27.12.2023.
//

import UIKit

class DetailedPasswordViewController: UIViewController {
    @IBOutlet weak var openLinkImageView: UIImageView!
    @IBOutlet weak var copyNameImageView: UIImageView!
    @IBOutlet weak var copyPasswordImageView: UIImageView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userTF: UITextField!
    var entity: Credential?
    @IBOutlet weak var copiedView: UIView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        setData(cred: entity ?? Credential(link: "", username: "", password: ""))
        
        openLinkImageView.addTapGestureRecognizer {
            self.openLinkInSafari(urlString: self.entity?.link ?? "https://google.com")
        }
        
        copyNameImageView.addTapGestureRecognizer {
            UIPasteboard.general.string = self.userTF.text ?? "None"
            self.showCopiedAlert()
        }
        
        copyPasswordImageView.addTapGestureRecognizer {
            UIPasteboard.general.string = self.passwordTF.text ?? "None"
            self.showCopiedAlert()
        }
        
        shareImageView.addTapGestureRecognizer {
            let itemsToShare = ["URL: \(self.entity?.link ?? "https://google.com")\nUsername: \(self.entity?.username ?? "Empty")\nPassword: \(self.entity?.password ?? "Empty")"]
            let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        deleteImageView.addTapGestureRecognizer {
            showDeleteAlert()
        }
        
        
        func showDeleteAlert() {
             let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
             let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
             alert.addAction(cancelAction)
             let deleteAction = UIAlertAction(title: "Delete Password", style: .destructive) { _ in
                 RealmManager.shared.deleteCredential(self.entity ?? Credential())
                 self.navigationController?.popViewController(animated: true)
             }
             alert.addAction(deleteAction)
             present(alert, animated: true, completion: nil)
        }
        
        editLabel.addTapGestureRecognizer {
            let vc = StoryboardScene.EditPassword.initialScene.instantiate()
            vc.modalPresentationStyle = .fullScreen
            vc.entity = self.entity
            vc.updateData = { entity in
                self.setData(cred: entity)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func setData(cred: Credential) {
        passwordTF.text = cred.password
        userTF.text = cred.username
        linkLabel.text = cred.link
    }
    
    func showCopiedAlert() {
        copiedView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.copiedView.isHidden = true
        })
    }
    
    func openLinkInSafari(urlString: String) {
        var urlStringWithHTTP = urlString

        if !urlStringWithHTTP.hasPrefix("http://") && !urlStringWithHTTP.hasPrefix("https://") {
            urlStringWithHTTP = "http://" + urlStringWithHTTP
        }

        if let url = URL(string: urlStringWithHTTP) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }    }
    
    
}
