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
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblPicture: UILabel!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension ScreenPostTableViewCell
{
    func setCollectionViewDatasoureDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource> (_ dataSourceDelegate: D, forRow row:Int)
    {
        pictureCollectionView.dataSource = dataSourceDelegate
        pictureCollectionView.delegate = dataSourceDelegate
        pictureCollectionView.reloadData()
    }
    
}
