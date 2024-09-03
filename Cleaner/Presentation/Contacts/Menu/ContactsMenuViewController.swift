//
//  ContactsMenuViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 20.10.2023.
//

import UIKit

class ContactsMenuViewController: UIViewController {
    
    @IBOutlet weak var incompleteView: UIView!
    @IBOutlet weak var duplicateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        incompleteView.addTapGestureRecognizer {
            let vc = StoryboardScene.IncompliteContacts.initialScene.instantiate()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
        duplicateView.addTapGestureRecognizer {
            let vc = StoryboardScene.DuplicateContacts.initialScene.instantiate()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
