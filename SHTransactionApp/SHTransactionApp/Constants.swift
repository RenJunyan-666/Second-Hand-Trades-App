struct T {
    static let appName = "✌️TradeApp"
    static let shippingTime = 8
    
    struct Cell {
        static let productCellNib = "ProductCell"
        static let orderCellNib = "OrderCell"
        static let carouselCell = "CarouselCell"
    }
    
    struct Ads {
        static let furniture = "furniture"
        static let phone = "phone-ads"
        static let jewelry = "jewelry-ads"
    }
    
    struct Identifier {
        static let registerSegue = "registerToHome"
        static let loginSegue = "loginToHome"
        
        static let userSegue = "homeToUser"
        static let userUpdateSegue = "userToUpdate"
        
        static let productCell = "productCell"
        static let productSegue = "homeToPurchase"
        static let productAddSegue = "productToAdd"
        static let productDetailSegue = "productToDetail"
        static let productUpdateSegue = "productDetailToUpdate"
        
        static let productListSegue = "homeToShopping"
        static let productInfoSegue = "productListToInfo"
        static let productOrderSegue = "productInfoToOrder"
        static let productSellerSegue = "productOrderToSeller"
        static let productReturnSegue = "productOrderToReturn"
        
        static let orderCell = "orderCell"
        static let returnOrderSegue = "returnToOrder"
        static let returnHomeSegue = "returnToHome"
        
        static let orderSegue = "homeToOrder"
        static let shippingSegue = "homeToShippingOrder"
        static let orderDetailSegue = "shippingToOrderDetail"
        static let shippingTrackSegue = "orderDetailToTrack"
        static let orderTrackSugue = "orderToTrack"
        static let shippedTrackSegue = "shippingOrderToTrack"
        static let trackHomeSegue = "trackToHome"
    }
    
    struct FStore {
        struct Collection {
            static let userCollection = "users"
            static let productCollection = "products"
            static let orderCollection = "orders"
        }
        
        struct User {
            static let name = "userName"
            static let city = "userCity"
            static let birthday = "userBirthday"
            static let phone = "userPhone"
            static let email = "userEmail"
        }
        
        struct Product {
            static let name = "productName"
            static let price = "productPrice"
            static let rating = "productRating"
            static let description = "productDescription"
            static let image = "productImage"
            static let postedDate = "productPostedDate"
            static let publisher = "productPublisher"
        }
        
        struct Order {
            static let productId = "productId"
            static let productImg = "productImage"
            static let price = "productPrice"
            static let status = "orderStatus"
            static let buyer = "orderBuyer"
            static let seller = "orderSeller"
            static let address = "orderAddress"
            static let payment = "orderPayment"
            
            static let statusPending = "pending"
            static let statusShipping = "shipping"
            static let statusCompleted = "completed"
            
            static let paymentCard = "card"
            static let paymentCash = "cash"
        }
    }
}
