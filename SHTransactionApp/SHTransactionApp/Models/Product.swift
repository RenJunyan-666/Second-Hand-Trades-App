import Foundation

class Product {
    let id: String
    let name: String
    let price: Double
    let rating: Int
    let description: String
    let image: Data
    let postedDate: String
    let publisher: String
    
    init(id: String, name: String, price: Double, rating: Int, description: String, image: Data, postedDate: String, publisher: String){
        self.id = id
        self.name = name
        self.price = price
        self.rating = rating
        self.description = description
        self.image = image
        self.postedDate = postedDate
        self.publisher = publisher
    }
}
