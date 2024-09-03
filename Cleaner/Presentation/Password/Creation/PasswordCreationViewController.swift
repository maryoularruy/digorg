//
//  PasswordCreationViewController.swift
//  Cleaner
//
//  Created by Alex on 27.12.2023.
//

import UIKit

class PasswordCreationViewController: UIViewController {
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var urlTF: UITextField!
    var update: (() -> ())?
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        urlTF.becomeFirstResponder()
    }
    
    @IBAction func save(_ sender: Any) {
        DBService.shared.saveCredential(
            link: urlTF.text ?? "Empty",
            username: nameTF.text ?? "Empty",
            password: passwordTF.text ?? "Empty"
        )
        update?()
        self.dismiss(animated: true)
        
    }
}
