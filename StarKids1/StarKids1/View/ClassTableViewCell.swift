//
//  ClassTableViewCell.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/20/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblTeacherName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
