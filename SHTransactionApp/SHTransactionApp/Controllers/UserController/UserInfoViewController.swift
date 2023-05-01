//
//  UserInfoViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/11/23.
//

import UIKit
import Firebase

class UserInfoViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let db = Firestore.firestore()
    var userId = ""
    
    var alert = UIAlertController(title: "Attention", message: "Add Info First!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Detail"
        loadUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserInfo()
    }

    @IBAction func updatePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: T.Identifier.userUpdateSegue, sender: self)
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
                        self.userId = doc.documentID
                        self.nameLabel.text = data[T.FStore.User.name] as? String
                        self.cityLabel.text = data[T.FStore.User.city] as? String
                        self.phoneLabel.text = data[T.FStore.User.phone] as? String
                        self.birthdayLabel.text = data[T.FStore.User.birthday] as? String
                        self.emailLabel.text = data[T.FStore.User.email] as? String
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == T.Identifier.userUpdateSegue {
            let destinationVC = segue.destination as! UserUpdateViewController
            destinationVC.userId = self.userId
        }
    }
}
