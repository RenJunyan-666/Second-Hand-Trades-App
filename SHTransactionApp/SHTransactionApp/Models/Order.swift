import Foundation

class Order {
    let id: String
    let productId: String
    let price: Double
    let productImage: Data
    let status: String //pending, shipping, completed
    let buyer: String
    let seller: String
    let address: String
    let payment: String
    
    init(id: String, productId: String, price: Double, productImage: Data, status:String, buyer: String, seller: String, address: String, payment: String) {
        self.id = id
        self.productId = productId
        self.productImage = productImage
        self.price = price
        self.status = status
        self.buyer = buyer
        self.seller = seller
        self.address = address
        self.payment = payment
    }
}
