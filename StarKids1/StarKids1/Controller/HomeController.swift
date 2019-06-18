//
//  HomeController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
var selectPostId:String!

class HomeController: UIViewController {
    
    @IBOutlet weak var tblListPost: UITableView!
    @IBOutlet weak var imgUserAvatar: UIImageView!
    
    var listPost:Array<Post> = Array<Post>()
    var flagLike:Array<Int> = Array<Int>()
    var flagComment:Array<Int> = Array<Int>()
    var isStar:Bool = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tblListPost.dataSource = self
        tblListPost.delegate = self
        tblListPost.transform = CGAffineTransform (scaleX: 1,y: -1);
        imgUserAvatar.loadAvatar(link:currentUser.linkAvatar)
        
//        if let tabItems = tabBarController?.tabBar.items {
//            // In this case we want to modify the badge number of the third tab:
//            let tabItem = tabItems[2]
//            tabItem.badgeValue = "1"
//        }
        
        let tableNameLike = ref.child("Likes")
        tableNameLike.observe(.childAdded, with: { (snapshot1) in
            self.flagLike.append(Int(snapshot1.childrenCount) - 1)
            print("likecountSnap \(self.flagLike)")
        })
        
        let tableNameComment = ref.child("Comments")
        tableNameComment.observe(.childAdded, with: { (snapshot1) in
            self.flagComment.append(Int(snapshot1.childrenCount) - 1)
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
                let picture:String = (postDict?["picture"])! as! String
                var isLikeStr:String = "none"
                
                let tableIsLike = ref.child("Likes").child(snapshot.key)
                tableIsLike.observe(.childAdded, with: { (snapshot1) in
                    let postDict1 = snapshot1.value as? [String: Any]
                    if (postDict1 != nil) {
                        let userIdLike = (postDict1?["userId"]) as! String
                        if (userIdLike == currentUser.id) {
                            isLikeStr = snapshot1.key as! String
                        }
                    }
                    else {
                        print("Không có thông tin")
                    }
                })
                
                
                let tableNameUser = ref.child("Users").child(userPost).child("fullName")
                tableNameUser.observe(.value, with: { (snapshot1) in
                    nameUser = (snapshot1.value as? String)!
                })
                
                let tableNameLinkAvatarPost = ref.child("Users").child(userPost).child("linkAvatar")
                tableNameLinkAvatarPost.observe(.value, with: { (snapshot1) in
                    linkAvatarPost = (snapshot1.value as? String)!
                    let post:Post = Post(id: snapshot.key,userPost: userPost,nameuserPost: nameUser,linkAvatarPost: linkAvatarPost, date: date, time: time, content: content, likes: self.flagLike[self.listPost.count], comment: self.flagComment[self.listPost.count], isLike: isLikeStr, pictures: picture)
                    print("------ \(post)")
                    self.listPost.append(post)
                    self.tblListPost.reloadData()
                })
            }
            else
            {
                print("Không có post")
            }
        })
    }

    @IBAction func tap_View(_ sender: Any) {
        gotoScreenWithBack(idScreen: "scrCreatePost")
    }
    
    @IBAction func tap_txtPost(_ sender: Any) {
        gotoScreenWithBack(idScreen: "scrCreatePost")
    }
    @objc func likePost(_ sender: UIButton){
        if (sender.currentImage == UIImage(named: "starYellow"))
        {
            sender.setImage(UIImage(named: "star"), for: .normal)
            
            let tableLike = ref.child("Likes").child(listPost[sender.tag].id).child(listPost[sender.tag].isLike)
            
            tableLike.removeValue { error, _ in
                print(error)
            }
            
            let indexPath = NSIndexPath(row: sender.tag, section: 0)
            let cell = tblListPost.cellForRow(at: indexPath as IndexPath) as! ScreenPostTableViewCell
            cell.lblStar.text = String("\(listPost[sender.tag].likes - 1)")
            cell.lblStar.setNeedsDisplay()
            listPost[sender.tag].likes = listPost[sender.tag].likes - 1
            listPost[sender.tag].isLike = "none"
            
        }
        else
        {
            sender.setImage(UIImage(named: "starYellow"), for: .normal)
            
            let tableLike = ref.child("Likes").child(listPost[sender.tag].id)
            let like:Dictionary<String,String> = ["userId":currentUser.id]
            let refRandom = tableLike.childByAutoId()
            refRandom.setValue(like)
            
            let indexPath = NSIndexPath(row: sender.tag, section: 0)
            let cell = tblListPost.cellForRow(at: indexPath as IndexPath) as! ScreenPostTableViewCell
            cell.lblStar.text = String("\(listPost[sender.tag].likes + 1)")
            cell.lblStar.setNeedsDisplay()
            listPost[sender.tag].likes = listPost[sender.tag].likes + 1
            listPost[sender.tag].isLike = refRandom.key
            
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
        print("Bên trong số cell nha\(listPost.count)")
        return listPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ScreenPostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenPostTableViewCell
        cell.lblStar.layer.cornerRadius = 0.5 * cell.lblStar.bounds.size.width
        cell.lblStar.clipsToBounds = true
        print("Bên trong cell nha\(listPost)")
        cell.lblStar.text = String(listPost[indexPath.row].likes)
        cell.lblTimePost.text = listPost[indexPath.row].date + "  " + listPost[indexPath.row].time
        cell.lblUserName.text = listPost[indexPath.row].nameuserPost
        cell.lblContent.text = listPost[indexPath.row].content
        cell.lblComment.text = String(listPost[indexPath.row].comment) + " bình luận"
        var picArr:Array<String> = Array<String>()
        picArr = listPost[indexPath.row].pictures.components(separatedBy: ";")
        cell.lblPicture.text = String(picArr.count) + " ảnh"
        cell.imgAvatar.loadAvatar(link: listPost[indexPath.row].linkAvatarPost)
        
        cell.btnStar.tag = indexPath.row;
        if (listPost[indexPath.row].isLike != "none")
        {
            cell.btnStar.setImage(UIImage(named: "starYellow"), for: .normal)
        } else {
            cell.btnStar.setImage(UIImage(named: "star"), for: .normal)
        }
        cell.btnStar.addTarget(self, action: #selector(self.likePost(_:)), for: .touchUpInside)
        
        cell.pictureCollectionView.tag = indexPath.row
        cell.contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectPostId = listPost[indexPath.row].id
        gotoScreenWithBack(idScreen: "scrPostDetail")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    ///////////////////
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var picArr:Array<String> = Array<String>()
        picArr = listPost[collectionView.tag].pictures.components(separatedBy: ";")
        print("Số cell của ảnh trong post \(picArr.count)")
        return picArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicturePostCell", for: indexPath) as! PicturePostCollectionViewCell
        
        var picArr:Array<String> = Array<String>()
        picArr = listPost[collectionView.tag].pictures.components(separatedBy: ";")
        
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



