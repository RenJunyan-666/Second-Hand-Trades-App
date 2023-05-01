//
//  RegisterViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/11/23.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var alert = UIAlertController(title: "Attention", message: "error!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.alert.message = e.localizedDescription
                    popup(view: self, alert: self.alert)
                } else {
                    self.performSegue(withIdentifier: T.Identifier.registerSegue, sender: self)
                }
            }
        }
    }
    
    //MARK: - scroll up
    @objc func keyboardAction(notification: Notification){
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}
