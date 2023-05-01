//
//  OrderTableViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/14/23.
//

import UIKit
import Firebase

class OrderTableViewController: UITableViewController {
    var orders:[Order] = []
    let db = Firestore.firestore()
    
    var alert = UIAlertController(title: "Attention", message: "error!", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order List"
        tableView.register(UINib(nibName: T.Cell.orderCellNib, bundle: nil), forCellReuseIdentifier: T.Identifier.orderCell)
        loadOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadOrders()
    }
    
    func loadOrders(){
        db.collection(T.FStore.Collection.orderCollection).whereField(T.FStore.Order.buyer, isEqualTo: Auth.auth().currentUser?.email).addSnapshotListener { (snapshot, error) in
            self.orders = []
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let snapshotDocuments = snapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let id = doc.documentID
                        if let productId = data[T.FStore.Order.productId] as? String, let price = data[T.FStore.Order.price] as? Double, let image = data[T.FStore.Order.productImg] as? Data, let status = data[T.FStore.Order.status] as? String, let buyer = data[T.FStore.Order.buyer] as? String, let seller = data[T.FStore.Order.seller] as? String, let address = data[T.FStore.Order.address] as? String, let payment = data[T.FStore.Order.payment] as? String {
                            
                            let newOrder = Order(id: id, productId: productId, price: price, productImage: image, status: status, buyer: buyer, seller: seller, address: address, payment: payment)
                            self.orders.append(newOrder)

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
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: T.Identifier.orderCell, for: indexPath) as! OrderCell
        cell.statusLabel.text = "\(orders[indexPath.row].status)"
        cell.productImage.image = UIImage(data: orders[indexPath.row].productImage)
        
        //isPending -> yellow, isShipping -> lightGreen, isCompleted -> green
        if orders[indexPath.row].status == T.FStore.Order.statusPending {
            cell.contentView.backgroundColor = UIColor.yellow
        }
        if orders[indexPath.row].status == T.FStore.Order.statusCompleted {
            cell.contentView.backgroundColor = UIColor.green
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch orders[indexPath.row].status {
        case T.FStore.Order.statusPending:
            self.alert.message = "Seller has not shipped it!"
            popup(view: self, alert: self.alert)
        case T.FStore.Order.statusCompleted:
            self.alert.message = "Order has been completed!"
            popup(view: self, alert: self.alert)
        default:
            performSegue(withIdentifier: T.Identifier.orderTrackSugue, sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == T.Identifier.orderTrackSugue {
            let destinationVC = segue.destination as! OrderTrackViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.orderId = orders[indexPath.row].id
            }
         }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteId = orders[indexPath.row].id
            db.collection(T.FStore.Collection.orderCollection).document(deleteId).delete { error in
                if error != nil {
                    self.alert.message = error?.localizedDescription
                    popup(view: self, alert: self.alert)
                } else {
                    self.alert.message = "Delete Successfully!"
                    popup(view: self, alert: self.alert)
                }
            }
            self.orders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
