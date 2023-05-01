//
//  ProductOrderViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/14/23.
//

import UIKit
import Firebase

class ProductOrderViewController: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var paymentRadio: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var productId: String = ""
    var productPrice: Double = 0.0
    var sellerEmail: String = ""
    var imageData = Data()
    let db = Firestore.firestore()
    
    var alert = UIAlertController(title: "Attention", message: "Invalid Value!", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order Info"
        loadProduct()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProduct()
    }

    @IBAction func contactPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: T.Identifier.productSellerSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == T.Identifier.productSellerSegue {
            let destinationVC = segue.destination as! ProductSellerViewController
            destinationVC.userEmail = self.sellerEmail
        }
    }
    
    @IBAction func placeOrderPressed(_ sender: UIButton) {
        let address = addressText.text ?? ""
        let payment = paymentRadio.selectedSegmentIndex == 0 ? T.FStore.Order.paymentCard : T.FStore.Order.paymentCash
        if address != "" {
            if let email = Auth.auth().currentUser?.email {
                db.collection(T.FStore.Collection.orderCollection).addDocument(data: [
                    T.FStore.Order.productId: self.productId,
                    T.FStore.Order.price: self.productPrice,
                    T.FStore.Order.productImg: self.imageData,
                    T.FStore.Order.status: T.FStore.Order.statusPending,
                    T.FStore.Order.buyer: email,
                    T.FStore.Order.seller: self.sellerEmail,
                    T.FStore.Order.address: address,
                    T.FStore.Order.payment: payment
                ]) { error in
                    if let e = error {
                        self.alert.message = e.localizedDescription
                        popup(view: self, alert: self.alert)
                    } else { //成功添加
                        //删除该产品
                        self.db.collection(T.FStore.Collection.productCollection).document(self.productId).delete { error in
                            if error != nil {
                                self.alert.message = error?.localizedDescription
                                popup(view: self, alert: self.alert)
                            }
                        }
                        self.performSegue(withIdentifier: T.Identifier.productReturnSegue, sender: self)
                        self.alert.message = "Order Successfully!"
                        popup(view: self, alert: self.alert)
                    }
                }
            }
        } else {
            popup(view: self, alert: self.alert)
        }
    }
    
    func loadProduct(){
        db.collection(T.FStore.Collection.productCollection).document(productId).getDocument { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let doc = snapshot {
                    if let data = doc.data() {
                        if let image = data[T.FStore.Product.image] as? Data, let price = data[T.FStore.Product.price] as? Double, let publisher = data[T.FStore.Product.publisher] as? String {
                            self.productImage.image = UIImage(data: image)
                            self.imageData = image
                            self.productPrice = price
                            self.sellerEmail = publisher
                        }
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
