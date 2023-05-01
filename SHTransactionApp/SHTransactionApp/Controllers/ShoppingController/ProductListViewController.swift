//
//  ProductListViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/14/23.
//

import UIKit
import Firebase

class ProductListViewController: UITableViewController {
    var products:[Product] = []
    let db = Firestore.firestore()
    
    var alert = UIAlertController(title: "Attention", message: "error!", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Shopping"
        tableView.register(UINib(nibName: T.Cell.productCellNib, bundle: nil), forCellReuseIdentifier: T.Identifier.productCell)
        loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProducts()
    }
    
    //加载所有不属于当前用户的，且没有被下单的产品
    func loadProducts(){
        db.collection(T.FStore.Collection.productCollection).whereField(T.FStore.Product.publisher, isNotEqualTo: Auth.auth().currentUser?.email).addSnapshotListener { (snapshot, error) in
            self.products = []
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let snapshotDocuments = snapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let id = doc.documentID
                        if let name = data[T.FStore.Product.name] as? String, let price = data[T.FStore.Product.price] as? Double, let rating = data[T.FStore.Product.rating] as? Int, let description = data[T.FStore.Product.description] as? String, let image = data[T.FStore.Product.image] as? Data, let postedDate = data[T.FStore.Product.postedDate] as? String, let email = data[T.FStore.Product.publisher] as? String{
                            let newProduct = Product(id: id, name: name, price: price, rating: rating, description: description, image: image, postedDate: postedDate, publisher: email)
                            self.products.append(newProduct)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: T.Identifier.productCell, for: indexPath) as! ProductCell
        cell.nameText.text = "\(products[indexPath.row].name)"
        cell.priceText.text = "$\(products[indexPath.row].price)"
        cell.productImage.image = UIImage(data: products[indexPath.row].image)
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: T.Identifier.productInfoSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == T.Identifier.productInfoSegue {
            let destinationVC = segue.destination as! ProductInfoViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.productId = products[indexPath.row].id
            }
         }
    }
}
