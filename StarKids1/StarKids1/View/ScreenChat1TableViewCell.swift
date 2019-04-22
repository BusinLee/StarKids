//
//  ScreenChat1TableViewCell.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/21/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class ScreenChat1TableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
