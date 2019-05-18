//
//  ScreenPostTableViewCell.swift
//  StarKids1
//
//  Created by Thanh Lê on 5/17/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class ScreenPostTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTimePost: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    //Replace by
   var isStar:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btn_Star(_ sender: Any) {
        if (isStar)
        {
            btnStar.setImage(UIImage(named: "star"), for: .normal)
            isStar = false
        }
        else
        {
            btnStar.setImage(UIImage(named: "starYellow"), for: .normal)
            isStar = true
        }
    }
}
