//
//  ProductSellerViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/14/23.
//

import UIKit
import Firebase

class ProductSellerViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let db = Firestore.firestore()
    var userEmail: String = ""
    
    var alert = UIAlertController(title: "Attention", message: "error!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Seller Detail"
        loadUserInfo()
    }

    func loadUserInfo(){
        db.collection(T.FStore.Collection.userCollection).whereField(T.FStore.User.email, isEqualTo: self.userEmail).getDocuments { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let snapshotDocuments = snapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
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
}
