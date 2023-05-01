//
//  OrderTrackViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/15/23.
//

import UIKit
import Firebase

class OrderTrackViewController: UIViewController {
    @IBOutlet weak var trackNumLabel: UILabel!
    @IBOutlet weak var processBar: UIProgressView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var orderId: String = ""
    var timer = Timer()
    var totalTime = T.shippingTime
    var secondsPassed = 0
    let db = Firestore.firestore()
    
    var alert = UIAlertController(title: "Attention", message: "error!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "📦Track"
        trackNumLabel.text = orderId
        loadStart()
        loadEnd()
        loadStatus()
    }
    
    func loadStart() {
        db.collection(T.FStore.Collection.orderCollection).document(orderId).getDocument { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let doc = snapshot {
                    if let data = doc.data() {
                        if let seller = data[T.FStore.Order.seller] as? String {
                            self.loadCity(email: seller)
                        }
                    }
                }
            }
        }
    }
    
    func loadCity(email: String) {
        db.collection(T.FStore.Collection.userCollection).whereField(T.FStore.User.email, isEqualTo: email).getDocuments { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let snapshotDocuments = snapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        self.startLabel.text = data[T.FStore.User.city] as? String
                    }
                }
            }
        }
    }

    func loadEnd() {
        db.collection(T.FStore.Collection.orderCollection).document(orderId).getDocument { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let doc = snapshot {
                    if let data = doc.data() {
                        self.endLabel.text = data[T.FStore.Order.address] as? String
                    }
                }
            }
        }
    }
    
    func loadStatus() {
        db.collection(T.FStore.Collection.orderCollection).document(orderId).getDocument { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let doc = snapshot {
                    if let data = doc.data() {
                        if let status = data[T.FStore.Order.status] as? String {
                            if status == T.FStore.Order.statusShipping {
                                self.statusLabel.text = T.FStore.Order.statusShipping
                                self.shippingProcess()
                            } else {
                                self.statusLabel.text = T.FStore.Order.statusCompleted
                            }
                        }
                    }
                }
            }
        }
    }
    
    func shippingProcess() {
        timer.invalidate()
        processBar.progress = 0.0
        secondsPassed = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            processBar.progress = Float(secondsPassed) / Float(totalTime)
        }else{
            timer.invalidate()
            statusLabel.text = T.FStore.Order.statusCompleted
            //更新数据库中该订单状态
            db.collection(T.FStore.Collection.orderCollection).document(orderId).setData([
                T.FStore.Order.status: T.FStore.Order.statusCompleted
            ], merge: true)
        }
    }
}
