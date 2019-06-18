//
//  NoticeController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import UserNotifications

class NoticeController: UIViewController {

//    @IBAction func btnNotice(_ sender: Any) {
//        let content = UNMutableNotificationContent()
//        content.title = "The 5 seconds are up!"
//        content.subtitle = "They are up now!"
//        content.body = "The 5 seconds are really up!"
//        content.badge = 1
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//    }
    var listNotice:Array<Notice> = Array<Notice>()
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
                
                let tableNameLinkAvatarPost = ref.child("Users").child(userComment).child("linkAvatar")
                tableNameLinkAvatarPost.observe(.value, with: { (snapshot1) in
                    linkAvaCmt = (snapshot1.value as? String)!
                })
                
                let tableNameUser = ref.child("Users").child(userComment).child("fullName")
                tableNameUser.observe(.value, with: { (snapshot1) in
                    nameUser = (snapshot1.value as? String)!
                    
                    let notice:Notice = Notice(idNotice: snapshot.key, postId: postId, nameUserComment: nameUser,linkAvaCmt: linkAvaCmt, seen: seen, day: date, time: time)
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
            cell.contentView.backgroundColor = UIColor.clear
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 82))
            let color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
            whiteRoundedView.layer.backgroundColor = color.cgColor
            whiteRoundedView.layer.masksToBounds = true
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            cell.lblContent.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectPostId = listNotice[indexPath.row].postId
        gotoScreenWithBack(idScreen: "scrPostDetail")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
