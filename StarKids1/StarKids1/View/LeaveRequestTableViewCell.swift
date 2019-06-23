//
//  LeaveRequestTableViewCell.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class LeaveRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var imgStudent: UIImageView!
    @IBOutlet weak var lblStudent: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
