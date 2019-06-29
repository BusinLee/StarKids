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
    var selectPost:Post = Post()
    var like:Int = 0
    var cmt:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblComment.delegate = self
        tblComment.dataSource = self
        tblComment.allowsSelection = false;
        tblComment.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let tableNameLike = ref.child("Likes")
        tableNameLike.observe(.childAdded, with: { (snapshot1) in
            if (snapshot1.key == selectPostId)
            {
                self.like = Int(snapshot1.childrenCount) - 1
            }
        })
        
        let tableNameComment = ref.child("Comments")
        tableNameComment.observe(.childAdded, with: { (snapshot1) in
            if (snapshot1.key == selectPostId)
            {
                self.cmt = Int(snapshot1.childrenCount) - 1
            }
        })
        
        let tableName = ref.child("Posts")
        tableName.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            if (postDict != nil) {
                if (snapshot.key == selectPostId) {
                    let userPost:String = (postDict?["userPost"])! as! String
                    var nameUser: String = ""
                    var linkAvatarPost:String = ""
                    let date:String = (postDict?["date"])! as! String
                    let time:String = (postDict?["time"])! as! String
                    let content:String = (postDict?["content"])! as! String
                    let picture:String = (postDict?["picture"])! as! String
                    var isLikeStr:String = "none"
                    
                    let tableIsLike = ref.child("Likes").child(snapshot.key)
                    tableIsLike.observe(.childAdded, with: { (snapshot1) in
                        let postDict1 = snapshot1.value as? [String: Any]
                        if (postDict1 != nil) {
                            let userIdLike = (postDict1?["userId"]) as! String
                            if (userIdLike == currentUser.id) {
                                isLikeStr = snapshot1.key
                            }
                        }
                        else {
                            print("Không có thông tin")
                        }
                    })
                    
                    
                    let tableNameUser = ref.child("Teachers").child(userPost).child("fullName")
                    tableNameUser.observe(.value, with: { (snapshot1) in
                        nameUser = (snapshot1.value as? String)!
                    })
                    
                    let tableNameLinkAvatarPost = ref.child("Teachers").child(userPost).child("linkAvatar")
                    tableNameLinkAvatarPost.observe(.value, with: { (snapshot1) in
                        linkAvatarPost = (snapshot1.value as? String)!
                        self.selectPost = Post(id: selectPostId,userPost: userPost,nameuserPost: nameUser,linkAvatarPost: linkAvatarPost, date: date, time: time, content: content, likes: self.like, comment: self.cmt, isLike: isLikeStr, pictures: picture)
                        self.tblComment.reloadData()
                    })
                }
            }
            else
            {
                print("Không có post")
            }
        })
        
        let tableNameComments = ref.child("Comments").child(selectPostId)
        tableNameComments.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil)
            {
                let content :String = (postDict?["content"])! as! String
                let userId: String = (postDict?["userId"])! as! String
                let time: String = (postDict?["time"])! as! String
                let date: String = (postDict?["date"])! as! String
                
                let tableUsers = ref.child("Students").child(userId)
                tableUsers.observeSingleEvent(of: .value, with: { (snapshot1) in
                    let postDict1 = snapshot1.value as? [String: Any]
                    if (postDict1 != nil) {
                        let nameComment = (postDict1?["fullName"]) as! String
                        let linkAvatar = (postDict1?["linkAvatar"]) as! String
                        
                        let comment:Comment = Comment(content: content,userId:userId, nameUser: nameComment, linkAvatar: linkAvatar, day: date, time: time)
                        self.comments.append(comment)
                        self.tblComment.reloadData()
                    }
                    else {
                        let tableUsers = ref.child("Teachers").child(userId)
                        tableUsers.observeSingleEvent(of: .value, with: { (snapshot1) in
                            let postDict1 = snapshot1.value as? [String: Any]
                            if (postDict1 != nil) {
                                let nameComment = (postDict1?["fullName"]) as! String
                                let linkAvatar = (postDict1?["linkAvatar"]) as! String
                                
                                let comment:Comment = Comment(content: content,userId:userId, nameUser: nameComment, linkAvatar: linkAvatar, day: date, time: time)
                                self.comments.append(comment)
                                self.tblComment.reloadData()
                                //self.lblComment.text = String(self.comments.count) + " bình luận"
                            }
                            else {
                                print("Không có thông tin")
                            }
                        })
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
                self.view.frame.origin.y -= (keyboardSize.height - 50)
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
        if (currentUser.id != selectPost.userPost && currentUser.role == "student") {
            let notice:Dictionary<String, Any> = ["userComment":currentUser.id,"seen": false, "date":day, "time": "\(hour)"+":"+"\(minute)","postId":selectPost.id, "content": "bình luận"]
            let tableNameNotice = ref.child("Notices").child(selectPost.userPost)
            tableNameNotice.childByAutoId().setValue(notice)
        }
    }
    @objc func likePost(_ sender: UIButton){
        if (sender.currentImage == UIImage(named: "starYellow"))
        {
            sender.setImage(UIImage(named: "star"), for: .normal)
            
            let tableLike = ref.child("Likes").child(selectPost.id).child(selectPost.isLike)
            
            tableLike.removeValue { error, _ in
                print(error)
            }
            
            let indexPath = NSIndexPath(row: sender.tag, section: 0)
            let cell = tblComment.cellForRow(at: indexPath as IndexPath) as! ScreenPostTableViewCell
            cell.lblStar.text = String("\(selectPost.likes - 1)")
            cell.lblStar.setNeedsDisplay()
            selectPost.likes = selectPost.likes - 1
            selectPost.isLike = "none"
            
        }
        else
        {
            sender.setImage(UIImage(named: "starYellow"), for: .normal)
            
            let tableLike = ref.child("Likes").child(selectPost.id)
            let like:Dictionary<String,String> = ["userId":currentUser.id]
            let refRandom = tableLike.childByAutoId()
            refRandom.setValue(like)
            
            let indexPath = NSIndexPath(row: sender.tag, section: 0)
            let cell = tblComment.cellForRow(at: indexPath as IndexPath) as! ScreenPostTableViewCell
            cell.lblStar.text = String("\(selectPost.likes + 1)")
            cell.lblStar.setNeedsDisplay()
            selectPost.likes = selectPost.likes + 1
            selectPost.isLike = refRandom.key
        }
    }
}
extension DetailPostController:UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (selectPostId == selectPost.id)
        {
            return comments.count + 1
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            var picArr:Array<String> = Array<String>()
            picArr = selectPost.pictures.components(separatedBy: ";")
            tableView.rowHeight = 268
            let cell:ScreenPostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenPostTableViewCell
            cell.lblStar.layer.cornerRadius = 0.5 * cell.lblStar.bounds.size.width
            cell.lblStar.clipsToBounds = true
            cell.lblStar.text = String(selectPost.likes)
            cell.lblTimePost.text = selectPost.date + "  " + selectPost.time
            cell.lblUserName.text = selectPost.nameuserPost
            cell.lblContent.text = selectPost.content
            cell.lblComment.text = String(selectPost.comment) + " bình luận"
            cell.lblPicture.text = String(picArr.count) + " ảnh"
            cell.imgAvatar.loadAvatar(link: selectPost.linkAvatarPost)

            cell.btnStar.tag = indexPath.row;
            if (selectPost.isLike != "none")
            {
                cell.btnStar.setImage(UIImage(named: "starYellow"), for: .normal)
            } else {
                cell.btnStar.setImage(UIImage(named: "star"), for: .normal)
            }
            cell.btnStar.addTarget(self, action: #selector(self.likePost(_:)), for: .touchUpInside)
            return cell
        }
        else
        {
            tableView.rowHeight = 99
            let cell:CommentViewCell = tableView.dequeueReusableCell(withIdentifier: "CellComment", for: indexPath) as! CommentViewCell
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

        let pictureRef = storageRef.child("posts/\(picArr[indexPath.row])")
        pictureRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Không load được hình từ bài post")
            } else {
                cell.imgPicturePost.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
}
