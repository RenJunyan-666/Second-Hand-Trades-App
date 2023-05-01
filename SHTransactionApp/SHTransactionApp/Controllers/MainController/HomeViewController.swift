//
//  HomeViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/11/23.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet weak var carouselView: UICollectionView!
    @IBOutlet weak var carouselControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    let db = Firestore.firestore()
    var userId:String = ""
    var hasProduct: Bool = false
    var hasOrder: Bool = false
    var hasShippingOrder: Bool = false
    
    let ads = [T.Ads.furniture, T.Ads.phone, T.Ads.jewelry]
    var timer: Timer?
    var currentCellIndex = 0
    
    var alert = UIAlertController(title: "Attention", message: "Please edit your profile first!", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = T.appName
        navigationItem.hidesBackButton = true
        let email = Auth.auth().currentUser?.email
        titleLabel.text = "Welcome \(email ?? "")"
        loadUserInfo()
        loadProduct()
        loadOrder()
        loadShippingOrder()
        
        //carousel timer
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
        carouselControl.numberOfPages = ads.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserInfo()
        loadProduct()
        loadOrder()
        loadShippingOrder()
    }

    @IBAction func purchasePressed(_ sender: UIBarButtonItem) {
        //如果没有编辑个人信息，则无法发布产品
        if self.userId == "" {
            popup(view: self, alert: self.alert)
        } else {
            self.performSegue(withIdentifier: T.Identifier.productSegue, sender: self)
        }
    }
    
    @IBAction func shoppingPressed(_ sender: UIBarButtonItem) {
        if hasProduct {
            self.performSegue(withIdentifier: T.Identifier.productListSegue, sender: self)
        } else {
            self.alert.message = "No Products!"
            popup(view: self, alert: self.alert)
        }
    }
    
    @IBAction func mePressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: T.Identifier.userSegue, sender: self)
    }
    
    @IBAction func orderPressed(_ sender: UIBarButtonItem) {
        //没有订单则不能看订单
        if hasOrder {
            self.performSegue(withIdentifier: T.Identifier.orderSegue, sender: self)
        } else {
            self.alert.message = "No Orders!"
            popup(view: self, alert: self.alert)
        }
    }
    
    @IBAction func billPressed(_ sender: UIBarButtonItem) {
        if hasShippingOrder {
            self.performSegue(withIdentifier: T.Identifier.shippingSegue, sender: self)
        } else {
            self.alert.message = "No Shipping Orders!"
            popup(view: self, alert: self.alert)
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
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
                        self.userId = doc.documentID
                    }
                }
            }
        }
    }
    
    func loadProduct(){
        db.collection(T.FStore.Collection.productCollection).whereField(T.FStore.Product.publisher, isNotEqualTo: Auth.auth().currentUser?.email).getDocuments { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let snapshotDocuments = snapshot?.documents {
                    if snapshotDocuments.count != 0 {
                        self.hasProduct = true
                    } else {
                        self.hasOrder = false
                    }
                }
            }
        }
    }
    
    func loadOrder(){
        db.collection(T.FStore.Collection.orderCollection).whereField(T.FStore.Order.buyer, isEqualTo: Auth.auth().currentUser?.email).getDocuments { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let snapshotDocuments = snapshot?.documents {
                    if snapshotDocuments.count != 0 {
                        self.hasOrder = true
                    } else {
                        self.hasOrder = false
                    }
                }
            }
        }
    }
    
    func loadShippingOrder(){
        db.collection(T.FStore.Collection.orderCollection).whereField(T.FStore.Order.seller, isEqualTo: Auth.auth().currentUser?.email).getDocuments { (snapshot, error) in
            if let e = error {
                self.alert.message = e.localizedDescription
                popup(view: self, alert: self.alert)
            } else {
                if let snapshotDocuments = snapshot?.documents {
                    if snapshotDocuments.count != 0 {
                        self.hasShippingOrder = true
                    } else {
                        self.hasShippingOrder = false
                    }
                }
            }
        }
    }
    
    @objc func slideToNext() {
        if currentCellIndex < ads.count-1 {
            currentCellIndex += 1
        } else {
            currentCellIndex = 0
        }
        carouselControl.currentPage = currentCellIndex
        carouselView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .right, animated: true)
    }
}

//MARK: - carousel methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = carouselView.dequeueReusableCell(withReuseIdentifier: T.Cell.carouselCell, for: indexPath) as! CarouselCollectionViewCell
        cell.adsImage.image = UIImage(named: ads[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: carouselView.frame.width, height: carouselView.frame.height)
    }
}
