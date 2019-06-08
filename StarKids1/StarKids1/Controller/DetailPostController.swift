//
//  DetailPostController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/3/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase

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
    
    var comments:Array<Comment> = Array<Comment>()
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionPicture.delegate = self
        collectionPicture.dataSource = self
        tblComment.delegate = self
        tblComment.dataSource = self
        tblComment.separatorStyle = UITableViewCell.SeparatorStyle.none
        imgAvatarPost.loadAvatar(link: selectPost.linkAvatarPost)
        lblNamePost.text = selectPost.userPost
        lblTimePost.text = selectPost.date + " "+selectPost.time
        lblContent.text = selectPost.content
        lblNumberPicture.text = String(selectPost.pictures.count) + " ảnh "
        lblNumberStar.layer.cornerRadius = 0.5 * lblNumberStar.bounds.size.width
        lblNumberStar.clipsToBounds = true
        lblNumberStar.text = String(selectPost.likes.count)
        lblComment.text = String(selectPost.comment) + " bình luận"
        if (selectPost.likes.contains(currentUser.id))
        {
            btnStar.setImage(UIImage(named: "starYellow"), for: .normal)
            // isStar = true
        } else {
            btnStar.setImage(UIImage(named: "star"), for: .normal)
        }
        
        
        let tableNameComments = ref.child("Comments").child(selectPost.id)
        tableNameComments.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil)
            {
                print("vooooo")
                let content :String = (postDict?["content"])! as! String
                let userId: String = (postDict?["userId"])! as! String
                let time: String = (postDict?["time"])! as! String
                let date: String = (postDict?["date"])! as! String
                
                let tableUsers = ref.child("Users").child(userId)
                tableUsers.observeSingleEvent(of: .value, with: { (snapshot1) in
                    //for child in snapshot1.children {
//                    print("ahihi\(self.comments.count)")
//                    print("vooooo2222")
//                    print("child \(self.comments[i].userId)")
                    //                        let snap = child as! DataSnapshot
                    //                        let nameComment:String = snap.value(forKey: "fullName") as! String
                    //                        let linkAvatar:String = snap.value(forKey: "linkAvatar") as! String
                    let postDict1 = snapshot1.value as? [String: Any]
                    if (postDict1 != nil) {
                        let nameComment = (postDict1?["fullName"]) as! String
                        let linkAvatar = (postDict1?["linkAvatar"]) as! String
                        
                        print("vooooo3333")
                        let comment:Comment = Comment(content: content,userId:userId, nameUser: nameComment, linkAvatar: linkAvatar, day: date, time: time)
                        self.comments.append(comment)
                        print("affffffff\(self.comments)")
                        self.tblComment.reloadData()
                    }
                    else {
                        print("Không có thông tin")
                    }
                })
                
                
//                let comment:Comment = Comment(content: content,userId:userId, nameUser: "", linkAvatar: "")
//                self.comments.append(comment)
//                if (self.comments.count == selectPost.comment) {
//                    let element = self.comments.count - 1
//                    for i in 0 ... element {
//                        self.getInfoUserComment(i: i)
//                        if (i == element) {
//                            self.tblComment.reloadData()
//                        }
//                    }
//                }
            }
            else
            {
                print("Không có bình luận")
            }
        })
    }
}
extension DetailPostController:UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentViewCell = tableView.dequeueReusableCell(withIdentifier: "CellComment", for: indexPath) as! CommentViewCell
        print("cell \(indexPath.row)")
        cell.imgAvatarComment.loadAvatar(link: comments[indexPath.row].linkAvatar)
        cell.lblNameComment.text = comments[indexPath.row].nameUser
        cell.lblContent.text = comments[indexPath.row].content
        cell.lblTime.text = comments[indexPath.row].day + " " + comments[indexPath.row].time
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
