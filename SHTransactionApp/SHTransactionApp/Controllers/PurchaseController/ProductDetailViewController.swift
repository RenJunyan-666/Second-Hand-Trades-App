//
//  ProductDetailViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/13/23.
//

import UIKit
import Firebase

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    let db = Firestore.firestore()
    var productId:String = ""
    let stars = ["⭐", "⭐⭐", "⭐⭐⭐", "⭐⭐⭐⭐", "⭐⭐⭐⭐⭐"]
    
    var alert = UIAlertController(title: "Attention", message: "error!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Detail"
        loadProductDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProductDetail()
    }

    @IBAction func updatePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: T.Identifier.productUpdateSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == T.Identifier.productUpdateSegue {
            let destinationVC = segue.destination as! ProductUpdateViewController
            destinationVC.productId = self.productId
        }
    }
    
    func loadProductDetail(){
        db.collection(T.FStore.Collection.productCollection).document(productId).getDocument { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let doc = snapshot {
                    if let data = doc.data() {
                        if let name = data[T.FStore.Product.name] as? String, let price = data[T.FStore.Product.price] as? Double, let rating = data[T.FStore.Product.rating] as? Int, let description = data[T.FStore.Product.description] as? String, let image = data[T.FStore.Product.image] as? Data, let postedDate = data[T.FStore.Product.postedDate] as? String {
                            self.productImage.image = UIImage(data: image)
                            self.nameLabel.text = name
                            self.priceLabel.text = "$\(price)"
                            self.descriptionLabel.text = description
                            self.ratingLabel.text = "\(self.stars[rating-1])"
                            self.postedDateLabel.text = postedDate
                        }
                    }
                }
            }
        }
    }
}
