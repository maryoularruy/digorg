//
//  EditPasswordViewController.swift
//  Cleaner
//
//  Created by Alex on 27.12.2023.
//

import UIKit

class EditPasswordViewController: UIViewController {
    var entity: Credential?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var urlTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var updateData: ((Credential) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        passwordTF.text = entity?.password ?? "Empty"
        userTF.text = entity?.username ?? "Empty"
        urlTF.text = entity?.link ?? "Empty"
    }
    
    
    
    @IBAction func save(_ sender: Any) {
        DBService.shared.updateCredential(
            entity ?? Credential(link: "", username: "", password: ""),
            withLink: urlTF.text ?? "Empty",
            username: userTF.text ?? "Empty",
            password: passwordTF.text ?? "Empty"
        )
        updateData?(Credential(link: urlTF.text ?? "Empty", username: userTF.text ?? "Empty", password: passwordTF.text ?? "Empty"))
        self.navigationController?.popViewController(animated: true)
    }
}
