//
//  WelcomeViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/11/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //title label animation
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "✌️TradeApp"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1*charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }

}
