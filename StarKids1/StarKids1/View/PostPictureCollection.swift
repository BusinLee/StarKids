//
//  PostPictureCollection.swift
//  StarKids1
//
//  Created by Thanh Lê on 5/30/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class PostPictureCollection: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func awakeFromNib() {
        self.dataSource = self
        self.delegate = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicturePostCell", for: indexPath) as! PicturePostCollectionViewCell
        return cell
    }

}
