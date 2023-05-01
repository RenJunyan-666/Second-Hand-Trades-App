import Foundation

//MARK: - valid phone number
func validPhone(phone: String) -> Bool {
    if phone == "" {
        return false
    }
    return phone.count == 10
}

//MARK: - valid rating
func validRating(rating:Int) -> Bool{
    return rating >= 1 && rating <= 5
}

//MARK: - valid double from string
func strToDouble(str:String) -> Double{
    if let num = Double(str) {
        return num
    } else {
        return -1.0
    }
}

//MARK: - valid int from string
func strToInt(str: String?) -> Int{
    if let validStr = str {
        if let num = Int(validStr) {
            return num
        } else {
            return -1
        }
    } else {
        return -1
    }
}
