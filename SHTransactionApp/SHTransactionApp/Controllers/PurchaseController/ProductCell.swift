//
//  ProductCell.swift
//  SHTransactionApp
//
//  Created by Junyan Ren on 4/13/23.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
