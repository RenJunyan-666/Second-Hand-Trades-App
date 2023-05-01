import Foundation

class User {
    var id: String
    var name: String
    var birthday: Date
    var city: String
    var cellphone: String
    var email: String
    
    init(id: String, name: String, birthday: Date, city: String, cellphone: String, email: String){
        self.id = id
        self.name = name
        self.birthday = birthday
        self.city = city
        self.cellphone = cellphone
        self.email = email
    }
}
