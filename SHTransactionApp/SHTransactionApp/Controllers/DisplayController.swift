import Foundation
import UIKit
import Firebase

//MARK: - display date as string
func showDate(date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateStr = dateFormatter.string(from: date)
    return dateStr
}

//MARK: - Alert
func popup(view: UIViewController, alert: UIAlertController){
    view.present(alert, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        alert.dismiss(animated: true, completion: nil)
    }
}
