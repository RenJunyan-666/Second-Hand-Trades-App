//
//  OrderDetailViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/15/23.
//

import UIKit
import Firebase

class OrderDetailViewController: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyerLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    
    let db = Firestore.firestore()
    var orderId: String = ""
    
    var alert = UIAlertController(title: "Attention", message: "error!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order Detail"
        loadOrderDetail()
    }

    @IBAction func shippingPressed(_ sender: UIButton) {
        db.collection(T.FStore.Collection.orderCollection).document(orderId).setData([
            T.FStore.Order.status: T.FStore.Order.statusShipping
        ], merge: true)
        self.performSegue(withIdentifier: T.Identifier.shippingTrackSegue, sender: self)
        self.alert.message = "Shipping Successfully!"
        popup(view: self, alert: self.alert)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == T.Identifier.shippingTrackSegue {
            let destinationVC = segue.destination as! ShippingOrderTrackViewController
            destinationVC.orderId = orderId
         }
    }
    
    func loadOrderDetail(){
        db.collection(T.FStore.Collection.orderCollection).document(orderId).getDocument { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let doc = snapshot {
                    if let data = doc.data() {
                        if let image = data[T.FStore.Order.productImg] as? Data, let price = data[T.FStore.Order.price] as? Double, let buyer = data[T.FStore.Order.buyer] as? String,  let address = data[T.FStore.Order.address] as? String, let payment = data[T.FStore.Order.payment] as? String {
                            self.productImage.image = UIImage(data: image)
                            self.priceLabel.text = "$\(price)"
                            self.buyerLabel.text = "buyer: \(buyer)"
                            self.addressLabel.text = "address: \(address)"
                            self.paymentLabel.text = "payment: \(payment)"
                        }
                    }
                }
            }
        }
    }
}
