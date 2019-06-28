//
//  NoticeController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import UserNotifications

let noticeCount = UserDefaults.standard
class NoticeController: UIViewController {
    var listNotice:Array<Notice> = Array<Notice>()
    var flagNotice:Int = 0
    @IBOutlet weak var tblNotice: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
//
//        })
        tblNotice.dataSource = self
        tblNotice.delegate = self
        let tableName = ref.child("Notices").child(currentUser.id)
        tableName.observe(.childAdded) { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil) {
                let userComment:String = (postDict?["userComment"])! as! String
                let seen:Bool = (postDict?["seen"])! as! Bool
                let date:String = (postDict?["date"])! as! String
                let time:String = (postDict?["time"])! as! String
                let postId:String = (postDict?["postId"])! as! String
                var nameUser:String = ""
                var linkAvaCmt:String = ""
                
                let tableNameLinkAvatarPost = ref.child("Students").child(userComment).child("linkAvatar")
                tableNameLinkAvatarPost.observe(.value, with: { (snapshot1) in
                    linkAvaCmt = (snapshot1.value as? String)!
                })
                
                let tableNameUser = ref.child("Students").child(userComment).child("fullName")
                tableNameUser.observe(.value, with: { (snapshot1) in
                    nameUser = (snapshot1.value as? String)!
                    
                    let notice:Notice = Notice(idNotice: snapshot.key, postId: postId, userCmt: userComment, nameUserComment: nameUser,linkAvaCmt: linkAvaCmt, seen: seen, day: date, time: time)
                    if (!seen) {
                        if let tabItems = self.tabBarController?.tabBar.items {
                            self.flagNotice = self.flagNotice + 1
                            noticeCount.set(self.flagNotice, forKey: "noticeCount")
                            let tabItem = tabItems[2]
                            tabItem.badgeValue = String(self.flagNotice)
                        }
                    }
                    self.listNotice.append(notice)
                    self.tblNotice.reloadData()
                })
                
            }
            else {
                print("Không có thông báo!")
            }
        }
    }

}
extension NoticeController : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NoticeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoticeTableViewCell
        cell.imgUserCmt.loadAvatar(link: listNotice[indexPath.row].linkAvaCmt)
        cell.lblContent.text = listNotice[indexPath.row].nameUserComment + " đã bình luận bài viết của bạn"
        cell.lblTime.text = listNotice[indexPath.row].day + "  " + listNotice[indexPath.row].time
    
        if (!listNotice[indexPath.row].seen)
        {
            cell.contentView.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
            cell.lblContent.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tabItems = self.tabBarController?.tabBar.items {
            self.flagNotice = self.flagNotice - 1
            noticeCount.set(self.flagNotice, forKey: "noticeCount")
            let tabItem = tabItems[2]
            tabItem.badgeValue = String(self.flagNotice)
        }
        
        let notice:Dictionary<String, Any> = ["userComment":listNotice[indexPath.row].userCmt,"seen": true, "date":listNotice[indexPath.row].day, "time": listNotice[indexPath.row].time, "postId":listNotice[indexPath.row].postId]
        let tableNameNotice = ref.child("Notices").child(currentUser.id).child(listNotice[indexPath.row].idNotice)
        tableNameNotice.setValue(notice)
        
        let cell:NoticeTableViewCell = tableView.cellForRow(at: indexPath as IndexPath)! as! NoticeTableViewCell
        cell.contentView.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
        cell.lblContent.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
        
        selectPostId = listNotice[indexPath.row].postId
        gotoScreenWithBack(idScreen: "scrPostDetail")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:NoticeTableViewCell = tableView.cellForRow(at: indexPath as IndexPath)! as! NoticeTableViewCell
        cell.contentView.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
        cell.lblContent.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
        
    }
}
