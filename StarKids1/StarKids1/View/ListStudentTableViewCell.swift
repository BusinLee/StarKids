//
//  ListStudentTableViewCell.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/21/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class ListStudentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNameStudent: UILabel!
    @IBOutlet weak var imgStudent: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
