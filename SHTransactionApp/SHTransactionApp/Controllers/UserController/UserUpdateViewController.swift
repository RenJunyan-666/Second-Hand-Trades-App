//
//  UserUpdateViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/11/23.
//

import UIKit
import Firebase

class UserUpdateViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let db = Firestore.firestore()
    var userId = ""
    
    var alert = UIAlertController(title: "Attention", message: "Invalid Value!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update User"
        loadUserInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func savePressed(_ sender: UIButton) {
        let name = nameText.text ?? ""
        let city = cityText.text ?? ""
        let phone = phoneText.text ?? ""
        let birthday = birthDatePicker.date
        if name != "" && city != "" && validPhone(phone: phone) {
            //判断有无用户信息
            if self.userId != "" { //update
                db.collection(T.FStore.Collection.userCollection).document(userId).setData([
                    T.FStore.User.name: name,
                    T.FStore.User.city: city,
                    T.FStore.User.phone: phone,
                    T.FStore.User.birthday: showDate(date: birthday)
                ], merge: true)
                self.alert.message = "Update Successfully!"
                popup(view: self, alert: self.alert)
            } else { //add
                if let email = Auth.auth().currentUser?.email {
                    db.collection(T.FStore.Collection.userCollection).addDocument(data: [
                        T.FStore.User.name: name,
                        T.FStore.User.city: city,
                        T.FStore.User.phone: phone,
                        T.FStore.User.birthday: showDate(date: birthday),
                        T.FStore.User.email: email
                    ]) { error in
                        if let e = error {
                            self.alert.message = e.localizedDescription
                            popup(view: self, alert: self.alert)
                        } else {
                            self.nameText.text = ""
                            self.cityText.text = ""
                            self.phoneText.text = ""
                            
                            self.alert.message = "Edited Successfully!"
                            popup(view: self, alert: self.alert)
                        }
                    }
                }
            }
        } else {
            popup(view: self, alert: self.alert)
        }
    }
    
    func loadUserInfo(){
        db.collection(T.FStore.Collection.userCollection).whereField(T.FStore.User.email, isEqualTo: Auth.auth().currentUser?.email).getDocuments { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let snapshotDocuments = snapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        self.nameText.text = data[T.FStore.User.name] as? String
                        self.cityText.text = data[T.FStore.User.city] as? String
                        self.phoneText.text = data[T.FStore.User.phone] as? String
                    }
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
