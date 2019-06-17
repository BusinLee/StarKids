//
//  NoticeTableViewCell.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/17/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUserCmt: UIImageView!
    @IBOutlet weak var lblContent: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
