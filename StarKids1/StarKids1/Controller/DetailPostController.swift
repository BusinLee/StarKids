//
//  DetailPostController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/3/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class DetailPostController: UIViewController {

    @IBOutlet weak var imgAvatarPost: UIImageView!
    @IBOutlet weak var lblNamePost: UILabel!
    @IBOutlet weak var lblTimePost: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var collectionPicture: UICollectionView!
    @IBOutlet weak var lblNumberPicture: UILabel!
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var lblNumberStar: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var tblComment: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionPicture.delegate = self
        collectionPicture.dataSource = self
//        tblComment.delegate = self
//        tblComment.dataSource = self
        imgAvatarPost.loadAvatar(link: selectPost.linkAvatarPost)
        lblNamePost.text = selectPost.userPost
        lblTimePost.text = selectPost.date + " "+selectPost.time
        lblContent.text = selectPost.content
        lblNumberPicture.text = String(selectPost.pictures.count) + " ảnh "
        lblNumberStar.layer.cornerRadius = 0.5 * lblNumberStar.bounds.size.width
        lblNumberStar.clipsToBounds = true
        lblNumberStar.text = String(selectPost.likes.count)
        lblComment.text = String(selectPost.comments.count) + " bình luận"
        if (selectPost.likes.contains(currentUser.id))
        {
            btnStar.setImage(UIImage(named: "starYellow"), for: .normal)
            // isStar = true
        } else {
            btnStar.setImage(UIImage(named: "star"), for: .normal)
        }
    }

    
}
extension DetailPostController:UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectPost.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentViewCell
        return cell
    }
    
    ////////////
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectPost.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicturePostCell", for: indexPath) as! DetailPicPostCollectionViewCell
        
        let pictureRef = storageRef.child("avatars/\(selectPost.pictures[indexPath.row])")
        pictureRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Không load được hình từ bài post")
            } else {
                cell.imgPicture.image = UIImage(data: data!)
            }
        }
        return cell
    }
}
