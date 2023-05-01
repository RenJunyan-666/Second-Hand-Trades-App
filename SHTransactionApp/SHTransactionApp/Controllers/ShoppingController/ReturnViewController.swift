//
//  ReturnViewController.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/14/23.
//

import UIKit

class ReturnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order Completed!"
        navigationItem.hidesBackButton = true
    }
    @IBAction func checkPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: T.Identifier.returnOrderSegue, sender: self)
    }
    
    @IBAction func returnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: T.Identifier.returnHomeSegue, sender: self)
    }
}
