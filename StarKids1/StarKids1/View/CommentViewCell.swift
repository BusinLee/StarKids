//
//  CommentViewCell.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/4/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatarComment: UIImageView!
    @IBOutlet weak var lblNameComment: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
