//
//  ProductAddViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/13/23.
//

import UIKit
import Firebase

class ProductAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var ratingText: UITextField!
    @IBOutlet weak var postedDatePicker: UIDatePicker!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let db = Firestore.firestore()
    
    var alert = UIAlertController(title: "Attention", message: "Invalid Value!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Product"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func uploadPressed(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        let name = nameText.text ?? ""
        let price = strToDouble(str: priceText.text ?? "")
        let description = descriptionText.text ?? ""
        let rating = strToInt(str: ratingText.text)
        let postedDate = postedDatePicker.date
        
        if name != "" && price != -1.0 && description != "" && validRating(rating: rating) {
            if let email = Auth.auth().currentUser?.email, let safeImage = productImage.image {
                db.collection(T.FStore.Collection.productCollection).addDocument(data: [
                    T.FStore.Product.name: name,
                    T.FStore.Product.price: price,
                    T.FStore.Product.description: description,
                    T.FStore.Product.rating: rating,
                    T.FStore.Product.image: safeImage.pngData()! as Data,
                    T.FStore.Product.postedDate: showDate(date: postedDate),
                    T.FStore.Product.publisher: email
                ]) { error in
                    if let e = error {
                        self.alert.message = e.localizedDescription
                        popup(view: self, alert: self.alert)
                    } else { //成功添加
                        self.nameText.text = ""
                        self.priceText.text = ""
                        self.ratingText.text = ""
                        self.descriptionText.text = ""
                        
                        self.alert.message = "Added Successfully!"
                        popup(view: self, alert: self.alert)
                    }
                }
            } else { //没有当前登陆email或者图片
                self.alert.message = "Please upload image!"
                popup(view: self, alert: self.alert)
            }
        } else { //文本框输入无效
            popup(view: self, alert: self.alert)
        }
    }
    
    //MARK: - image picker controller methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        productImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
