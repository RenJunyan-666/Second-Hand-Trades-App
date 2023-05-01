//
//  OrderCell.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/15/23.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
