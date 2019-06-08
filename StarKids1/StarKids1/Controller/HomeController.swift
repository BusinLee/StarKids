//
//  HomeController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
var selectPost:Post!

class HomeController: UIViewController {
    
    @IBOutlet weak var tblListPost: UITableView!
    
    var listPost:Array<Post> = Array<Post>()
    var flagPicture:Array<String> = Array<String>()
    var flagLike:Array<String> = Array<String>()
    var flagComment:Array<Int> = Array<Int>()
    var isStar:Bool = false
    //var quantityArray:[Int] = []
    var text:Array<String> = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblListPost.dataSource = self
        tblListPost.delegate = self
        //tblListPost.allowsSelection = false;
        
        //        for i in 0 ..< 10 {
        //            quantityArray.append(1)
        //        }
        
        
        let tableNamePicture = ref.child("Pictures")
        tableNamePicture.observe(.childAdded, with: { (snapshot1) in
            self.flagPicture.append("\(snapshot1.childrenCount)")
            print("picturecountSnap \(self.flagPicture)")
        })
        
        let tableNameLike = ref.child("Likes")
        tableNameLike.observe(.childAdded, with: { (snapshot1) in
            self.flagLike.append("\(snapshot1.childrenCount)")
            print("likecountSnap \(self.flagLike)")
        })
        
        let tableNameComment = ref.child("Comments")
        tableNameComment.observe(.childAdded, with: { (snapshot1) in
            self.flagComment.append(Int(snapshot1.childrenCount))
            print("commentcountSnap \(self.flagComment)")
        })
        
        let tableName = ref.child("Posts")
        tableName.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            if (postDict != nil) {
                let userPost:String = (postDict?["userPost"])! as! String
                var nameUser: String = ""
                var linkAvatarPost:String = ""
                let date:String = (postDict?["date"])! as! String
                let time:String = (postDict?["time"])! as! String
                let content:String = (postDict?["content"])! as! String
                var likes:Array<String> = Array<String>()
                var pictures:Array<String> = Array<String>()
                
                
                
                let tableNameUser = ref.child("Users").child(userPost).child("fullName")
                tableNameUser.observe(.value, with: { (snapshot1) in
                    nameUser = (snapshot1.value as? String)!
                })
                
                let tableNameLinkAvatarPost = ref.child("Users").child(userPost).child("linkAvatar")
                tableNameLinkAvatarPost.observe(.value, with: { (snapshot1) in
                    linkAvatarPost = (snapshot1.value as? String)!
                })
                let tableNamePictures = ref.child("Pictures").child(snapshot.key)
                tableNamePictures.observe(.childAdded, with: { (snapshot1) in
                    let postDict1 = snapshot1.value as? [String:AnyObject]
                    if (postDict1 != nil)
                    {
                        let picture :String = (postDict1?["picture"])! as! String
                        pictures.append(picture)
                        print("picture----- \(picture)")
                        if (pictures.count == Int(self.flagPicture[self.listPost.count])) {
                            let post:Post = Post(id: snapshot.key,userPost: nameUser,linkAvatarPost: linkAvatarPost, date: date, time: time, content: content, likes: likes, comment: self.flagComment[self.listPost.count], pictures: pictures)
                            print("------ \(post)")
                            self.listPost.append(post)
                            self.getLikesForPosts()
                            self.text.append("abc")
                            self.tblListPost.reloadData()
                        }
                    }
                    else
                    {
                        print("Không có hình")
                    }
                })
            }
            else
            {
                print("Không có post")
            }
        })
        
    }
    
    func getLikesForPosts() {
        for i in 0 ... self.listPost.count - 1 {
            var likes:Array<String> = Array<String>()
            let tableNameLikes = ref.child("Likes").child(self.listPost[i].id)
            tableNameLikes.observe(.childAdded, with: { (snapshot1) in
                let postDict1 = snapshot1.value as? [String:AnyObject]
                if (postDict1 != nil)
                {
                    let like :String = (postDict1?["userId"])! as! String
                    likes.append(like)
                    print("picture----- \(like)")
                    if (likes.count == Int(self.flagLike[i])) {
                        self.listPost[i].likes = likes
                        print("picture+++++ \(self.listPost)")
                        self.text.append("abc")
                        self.tblListPost.reloadData()
                    }
                }
                else
                {
                    print("Không có hình")
                }
            })
        }
    }
//    func getLikesForPosts() {
//        for i in 0 ... self.listPost.count - 1 {
//            var likes:Array<String> = Array<String>()
//            let tableNameLikes = ref.child("Likes").child(self.listPost[i].id)
//            tableNameLikes.observeSingleEvent(of: .value, with: { (snapshot1) in
//                let postDict1 = snapshot1.value as? [String:AnyObject]
//                if (postDict1 != nil)
//                {
//                    for each in postDict1! {
//                        let like :String = each.value as! String
//                        likes.append(like)
//                        print("picture----- \(like)")
//                        if (likes.count == Int(self.flagLike[i])) {
//                            self.listPost[i].likes = likes
//
//                            print("picture+++++ \(self.listPost)")
//                            self.text.append("abc")
//                            self.tblListPost.reloadData()
//                        }
//                    }
//                }
//                else
//                {
//                    print("Không có hình")
//                }
//            })
//        }
//    }
    
//    if let participantsDict = snapshot.value as? [String : AnyObject] {
//        for each in participantsDict {
//            let employeeIDNum = each.key
//            self.getName(forUID: employeeIDNum)
//            self.employeeID.append(employeeIDNum)
//        }
    
    
    @objc func likePost(_ sender: UIButton){
        if (sender.currentImage == UIImage(named: "starYellow"))
        {
            sender.setImage(UIImage(named: "star"), for: .normal)
            // isStar = false
            var temp:Int = sender.tag + 1
            text[sender.tag] = "def \(temp)"
            
            
            let indexPath = NSIndexPath(row: sender.tag, section: 0)
            let cell = tblListPost.cellForRow(at: indexPath as IndexPath) as! ScreenPostTableViewCell
            cell.lblComment.text = "def \(temp)"
            cell.lblComment.setNeedsDisplay()
            //let increasedQty = [sender.tag]+1
            //self.quantityArray.replaceSubrange(sender.tag, with: increasedQty)
            
            
            //self.tblListPost.reloadData()
        }
        else
        {
            sender.setImage(UIImage(named: "starYellow"), for: .normal)
            // isStar = true
            
            var temp:Int = sender.tag - 1
            text[sender.tag] = "def \(temp)"
            
            let indexPath = NSIndexPath(row: sender.tag, section: 0)
            let cell = tblListPost.cellForRow(at: indexPath as IndexPath) as! ScreenPostTableViewCell
            cell.lblComment.text = "def \(temp)"
            cell.lblComment.setNeedsDisplay()
            
            //self.tblListPost.reloadData()
        }
    }
    
}

extension HomeController: UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ScreenPostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenPostTableViewCell
        cell.lblStar.layer.cornerRadius = 0.5 * cell.lblStar.bounds.size.width
        cell.lblStar.clipsToBounds = true
        cell.lblStar.text = String(listPost[indexPath.row].likes.count)
        cell.lblTimePost.text = listPost[indexPath.row].date + "  " + listPost[indexPath.row].time
        cell.lblUserName.text = listPost[indexPath.row].userPost
        cell.lblContent.text = listPost[indexPath.row].content
        cell.lblComment.text = String(listPost[indexPath.row].comment) + " bình luận"
        //cell.lblComment.text = text[indexPath.row]
        cell.lblPicture.text = String(listPost[indexPath.row].pictures.count) + " ảnh"
        cell.imgAvatar.loadAvatar(link: listPost[indexPath.row].linkAvatarPost)
        
        cell.btnStar.tag = indexPath.row;
        if (listPost[indexPath.row].likes.contains(currentUser.id))
        {
            cell.btnStar.setImage(UIImage(named: "starYellow"), for: .normal)
            // isStar = true
        } else {
            cell.btnStar.setImage(UIImage(named: "star"), for: .normal)
        }
        cell.btnStar.addTarget(self, action: #selector(self.likePost(_:)), for: .touchUpInside)
        
        cell.pictureCollectionView.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectPost = listPost[indexPath.row]
        print("++++++++++++\(selectPost)")
        gotoScreenWithBack(idScreen: "scrPostDetail")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    ///////////////////
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPost[collectionView.tag].pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicturePostCell", for: indexPath) as! PicturePostCollectionViewCell
        
        let pictureRef = storageRef.child("avatars/\(listPost[collectionView.tag].pictures[indexPath.row])")
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



