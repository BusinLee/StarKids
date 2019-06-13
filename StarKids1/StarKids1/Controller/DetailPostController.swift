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

    @IBOutlet weak var tblComment: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    
    var comments:Array<Comment> = Array<Comment>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblComment.delegate = self
        tblComment.dataSource = self
        tblComment.allowsSelection = false;
        tblComment.separatorStyle = UITableViewCell.SeparatorStyle.none
        
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
                    let postDict1 = snapshot1.value as? [String: Any]
                    if (postDict1 != nil) {
                        let nameComment = (postDict1?["fullName"]) as! String
                        let linkAvatar = (postDict1?["linkAvatar"]) as! String
                        
                        print("vooooo3333")
                        let comment:Comment = Comment(content: content,userId:userId, nameUser: nameComment, linkAvatar: linkAvatar, day: date, time: time)
                        self.comments.append(comment)
                        print("affffffff\(self.comments)")
                        self.tblComment.reloadData()
                        //self.lblComment.text = String(self.comments.count) + " bình luận"
                    }
                    else {
                        print("Không có thông tin")
                    }
                })
            }
            else
            {
                print("Không có bình luận")
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func btn_Comment(_ sender: Any) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let day = formatter.string(from: date)
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let comment:Dictionary<String,String> = ["content":txtComment.text!, "date":day, "time": "\(hour)"+":"+"\(minute)", "userId":currentUser.id]
        let tableNameComments = ref.child("Comments").child(selectPost.id)
        tableNameComments.childByAutoId().setValue(comment)
        txtComment.text = ""
    }
}
extension DetailPostController:UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            tableView.rowHeight = 268
            let cell:ScreenPostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenPostTableViewCell
            cell.lblStar.layer.cornerRadius = 0.5 * cell.lblStar.bounds.size.width
            cell.lblStar.clipsToBounds = true
            cell.lblStar.text = String(selectPost.likes)
            cell.lblTimePost.text = selectPost.date + "  " + selectPost.time
            cell.lblUserName.text = selectPost.userPost
            cell.lblContent.text = selectPost.content
            cell.lblComment.text = String(selectPost.comment) + " bình luận"
            cell.lblPicture.text = String(selectPost.pictures.count) + " ảnh"
            cell.imgAvatar.loadAvatar(link: selectPost.linkAvatarPost)
            
            cell.btnStar.tag = indexPath.row;
            if (selectPost.isLike != "none")
            {
                cell.btnStar.setImage(UIImage(named: "starYellow"), for: .normal)
            } else {
                cell.btnStar.setImage(UIImage(named: "star"), for: .normal)
            }
            //cell.btnStar.addTarget(self, action: #selector(self.likePost(_:)), for: .touchUpInside)
            return cell
        }
        else
        {
            tableView.rowHeight = 99
            let cell:CommentViewCell = tableView.dequeueReusableCell(withIdentifier: "CellComment", for: indexPath) as! CommentViewCell
            print("cell \(indexPath.row)")
            cell.imgAvatarComment.loadAvatar(link: comments[indexPath.row-1].linkAvatar)
            cell.lblNameComment.text = comments[indexPath.row-1].nameUser
            cell.lblContent.text = comments[indexPath.row-1].content
            cell.lblTime.text = comments[indexPath.row-1].day + " " + comments[indexPath.row-1].time
            return cell
        }
    }
    
    ////////////
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var picArr:Array<String> = Array<String>()
        picArr = selectPost.pictures.components(separatedBy: ";")
        return picArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicturePostCell", for: indexPath) as! PicturePostCollectionViewCell
        
        var picArr:Array<String> = Array<String>()
        picArr = selectPost.pictures.components(separatedBy: ";")
        
        let pictureRef = storageRef.child("avatars/\(picArr[indexPath.row])")
        pictureRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Không load được hình từ bài post")
            } else {
                cell.imgPicturePost.image = UIImage(data: data!)
                print("Vao collectionpost")
            }
        }
        
        return cell
    }
}
