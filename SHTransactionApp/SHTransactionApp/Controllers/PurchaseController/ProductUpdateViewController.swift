//
//  ProductUpdateViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/13/23.
//

import UIKit
import Firebase

class ProductUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var ratingText: UITextField!
    @IBOutlet weak var postedDatePicker: UIDatePicker!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let db = Firestore.firestore()
    var productId:String = ""
    
    var alert = UIAlertController(title: "Attention", message: "Invalid Value!", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Product"
        loadProduct()
        
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
    
    @IBAction func savePressed(_ sender: UIButton) {
        let name = nameText.text ?? ""
        let price = strToDouble(str: priceText.text ?? "")
        let description = descriptionText.text ?? ""
        let rating = strToInt(str: ratingText.text)
        let postedDate = postedDatePicker.date
        
        if name != "" && price != -1.0 && description != "" && validRating(rating: rating) {
            if let safeImage = productImage.image {
                db.collection(T.FStore.Collection.productCollection).document(productId).setData([
                    T.FStore.Product.name: name,
                    T.FStore.Product.price: price,
                    T.FStore.Product.description: description,
                    T.FStore.Product.rating: rating,
                    T.FStore.Product.postedDate: showDate(date: postedDate),
                    T.FStore.Product.image: safeImage.pngData()! as Data
                ], merge: true)
                self.alert.message = "Update Successfully!"
                popup(view: self, alert: self.alert)
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
                        if let name = data[T.FStore.Product.name] as? String, let price = data[T.FStore.Product.price] as? Double, let description = data[T.FStore.Product.description] as? String, let rating = data[T.FStore.Product.rating] as? Int, let image = data[T.FStore.Product.image] as? Data {
                            self.productImage.image = UIImage(data: image)
                            self.nameText.text = name
                            self.priceText.text = "\(price)"
                            self.descriptionText.text = description
                            self.ratingText.text = "\(rating)"
                        }
                    }
                }
            }
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
