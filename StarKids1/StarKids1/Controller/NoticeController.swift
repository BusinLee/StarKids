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
        
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItemm = tabItems[2]
            if (flagNotice == 0) {
                tabItemm.badgeValue = nil
            }
        }
        
        tblNotice.dataSource = self
        tblNotice.delegate = self
        tblNotice.transform = CGAffineTransform (scaleX: 1,y: -1);
        
        if (currentUser.role == "admin")
        {
            let tableNameTeacher = ref.child("Teachers")
            tableNameTeacher.observe(.childAdded) { (snapshot7) in
                let postDict7 = snapshot7.value as? [String:AnyObject]
                if (postDict7 != nil)
                {
                    let tableName = ref.child("Notices").child(snapshot7.key)
                    tableName.observe(.childAdded) { (snapshot) in
                        let postDict = snapshot.value as? [String:AnyObject]
                        if (postDict != nil) {
                            let userComment:String = (postDict?["userComment"])! as! String
                            let seen:Bool = (postDict?["seen"])! as! Bool
                            let date:String = (postDict?["date"])! as! String
                            let time:String = (postDict?["time"])! as! String
                            let postId:String = (postDict?["postId"])! as! String
                            let content:String = (postDict?["content"])! as! String
                            var nameUser:String = ""
                            var linkAvaCmt:String = ""
                            
                            if (content != "bình luận")
                            {
                                let tableNameLinkAvatarPost = ref.child("Students").child(userComment).child("linkAvatar")
                                tableNameLinkAvatarPost.observe(.value, with: { (snapshot1) in
                                    linkAvaCmt = (snapshot1.value as? String)!
                                })
                                
                                let tableNameUser = ref.child("Students").child(userComment).child("fullName")
                                tableNameUser.observe(.value, with: { (snapshot1) in
                                    nameUser = (snapshot1.value as? String)!
                                    
                                    let notice:Notice = Notice(idNotice: snapshot.key, postId: postId, userCmt: userComment, nameUserComment: nameUser,linkAvaCmt: linkAvaCmt, seen: seen, day: date, time: time, content: content, userSeen: "", idContent: "")
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
                            
                        }
                        else {
                            print("Không có thông báo!")
                        }
                    }
                }
            }
        }
        else
        {
            let tableName = ref.child("Notices").child(currentUser.id)
            tableName.observe(.childAdded) { (snapshot) in
                let postDict = snapshot.value as? [String:AnyObject]
                if (postDict != nil) {
                    let userComment:String = (postDict?["userComment"])! as! String
                    let seen:Bool = (postDict?["seen"])! as! Bool
                    let date:String = (postDict?["date"])! as! String
                    let time:String = (postDict?["time"])! as! String
                    let postId:String = (postDict?["postId"])! as! String
                    let content:String = (postDict?["content"])! as! String
                    var nameUser:String = ""
                    var linkAvaCmt:String = ""
                    
                    let tableNameLinkAvatarPost = ref.child("Students").child(userComment).child("linkAvatar")
                    tableNameLinkAvatarPost.observe(.value, with: { (snapshot1) in
                        linkAvaCmt = (snapshot1.value as? String)!
                    })
                    
                    let tableNameUser = ref.child("Students").child(userComment).child("fullName")
                    tableNameUser.observe(.value, with: { (snapshot1) in
                        nameUser = (snapshot1.value as? String)!
                        
                        let notice:Notice = Notice(idNotice: snapshot.key, postId: postId, userCmt: userComment, nameUserComment: nameUser,linkAvaCmt: linkAvaCmt, seen: seen, day: date, time: time, content: content, userSeen: "", idContent: "")
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
        
        if (currentUser.role != "admin")
        {
            tblNotice.dataSource = self
            tblNotice.delegate = self
            let tableName = ref.child("NoticesMore")
            tableName.observe(.childAdded) { (snapshot) in
                let postDict = snapshot.value as? [String:AnyObject]
                if (postDict != nil) {
                    let userSeen:String = (postDict?["userSeen"])! as! String
                    let date:String = (postDict?["date"])! as! String
                    let time:String = (postDict?["time"])! as! String
                    let content:String = (postDict?["content"])! as! String
                    let idContent:String = (postDict?["idContent"])! as! String
                    let notice:Notice = Notice(idNotice: snapshot.key, postId: "", userCmt: "", nameUserComment: "",linkAvaCmt: "", seen: false, day: date, time: time, content: content, userSeen: userSeen, idContent: idContent)
                    if (userSeen == "") {
                        if let tabItems = self.tabBarController?.tabBar.items {
                        self.flagNotice = self.flagNotice + 1
                        noticeCount.set(self.flagNotice, forKey: "noticeCount")
                        let tabItem = tabItems[2]
                        tabItem.badgeValue = String(self.flagNotice)
                        }
                    }
                    else
                    {
                        let seenArr = userSeen.components(separatedBy: ";")
                        if (!seenArr.contains(currentUser.id))
                        {
                            if let tabItems = self.tabBarController?.tabBar.items {
                                self.flagNotice = self.flagNotice + 1
                                noticeCount.set(self.flagNotice, forKey: "noticeCount")
                                let tabItem = tabItems[2]
                                tabItem.badgeValue = String(self.flagNotice)
                            }
                        }
                    }
                        self.listNotice.append(notice)
                        self.tblNotice.reloadData()
                }
                else {
                    print("Không có thông báo!")
                }
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
        if (listNotice[indexPath.row].postId != "")
        {
            cell.imgUserCmt.loadAvatar(link: listNotice[indexPath.row].linkAvaCmt)
            if (listNotice[indexPath.row].content == "bình luận")
            {
                cell.lblContent.text = listNotice[indexPath.row].nameUserComment + " đã bình luận bài viết của bạn"
            }
            else
            {
                cell.lblContent.text = listNotice[indexPath.row].nameUserComment + " đã nộp đơn xin nghỉ học mới"
            }
            cell.lblTime.text = listNotice[indexPath.row].day + "  " + listNotice[indexPath.row].time
            
            if (!listNotice[indexPath.row].seen)
            {
                cell.contentView.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
                cell.lblContent.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
            }
        }
        else
        {
            cell.imgUserCmt.image = UIImage(named: "logo")
            cell.lblContent.text = "Star Kids" + " đã thêm " + listNotice[indexPath.row].content + " mới"
            cell.lblTime.text = listNotice[indexPath.row].day + "  " + listNotice[indexPath.row].time
            let seenArr = listNotice[indexPath.row].userSeen.components(separatedBy: ";")
            if (!seenArr.contains(currentUser.id))
            {
                cell.contentView.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
                cell.lblContent.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
            }
        }
        cell.contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seenArr = listNotice[indexPath.row].userSeen.components(separatedBy: ";")
        if (listNotice[indexPath.row].postId != "")
        {
            if (!listNotice[indexPath.row].seen)
            {
                if let tabItems = self.tabBarController?.tabBar.items {
                    self.flagNotice = self.flagNotice - 1
                    noticeCount.set(self.flagNotice, forKey: "noticeCount")
                    let tabItem = tabItems[2]
                    tabItem.badgeValue = String(self.flagNotice)
                    
                    if (flagNotice == 0) {
                        tabItem.badgeValue = nil
                    }
                }
                
                let notice:Dictionary<String, Any> = ["userComment":listNotice[indexPath.row].userCmt,"seen": true, "date":listNotice[indexPath.row].day, "time": listNotice[indexPath.row].time, "postId":listNotice[indexPath.row].postId, "content": listNotice[indexPath.row].content]
                let tableNameNotice = ref.child("Notices").child(currentUser.id).child(listNotice[indexPath.row].idNotice)
                tableNameNotice.setValue(notice)
                
                listNotice[indexPath.row].seen = true
            }
            
            
            let cell:NoticeTableViewCell = tableView.cellForRow(at: indexPath as IndexPath)! as! NoticeTableViewCell
            cell.contentView.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
            cell.lblContent.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
            
            if (listNotice[indexPath.row].content == "bình luận")
            {
                selectPostId = listNotice[indexPath.row].postId
                gotoScreenWithBack(idScreen: "scrPostDetail")
            }
            else
            {
                let tableName = ref.child("LeaveRequests")
                tableName.observe(.childAdded) { (snapshot) in
                    let postDict = snapshot.value as? [String:AnyObject]
                    if (postDict != nil) {
                        if (snapshot.key == self.listNotice[indexPath.row].postId)
                        {
                            let currentDay:String = (postDict?["currentDay"])! as! String
                            let fromDay:String = (postDict?["fromDay"])! as! String
                            let parentt:String = (postDict?["parent"])! as! String
                            let reason:String = (postDict?["reason"])! as! String
                            let studentId:String = (postDict?["studentId"])! as! String
                            let toDay:String = (postDict?["toDay"])! as! String
                            var fullName:String = ""
                            var linkAvatar:String = ""
                            var parentName:String = ""
                            var classId:String = ""
                            var className:String = ""
                            let tableUsers = ref.child("Students").child(studentId)
                            tableUsers.observeSingleEvent(of: .value, with: { (snapshot1) in
                                let postDict1 = snapshot1.value as? [String: Any]
                                if (postDict1 != nil) {
                                    fullName = (postDict1?["fullName"]) as! String
                                    linkAvatar = (postDict1?["linkAvatar"]) as! String
                                    classId = (postDict1?["className"]) as! String
                                    if (parentt == "ba")
                                    {
                                        parentName = (postDict1?["fatherName"]) as! String
                                    }
                                    else
                                    {
                                        parentName = (postDict1?["motherName"]) as! String
                                    }
                                    
                                    let tableNameClass = ref.child("Classes").child(classId).child("className")
                                    tableNameClass.observe(.value, with: { (snapshot2) in
                                        className = (snapshot2.value as? String)!
                                        
                                        selectedLeaveRequest = LeaveRequest(id: snapshot.key, currentDay: currentDay, fromDay: fromDay, toDay: toDay, reason: reason, fullName: fullName, parent: parentName, linkAvatar: linkAvatar, className: className)
                                        self.gotoScreenWithBack(idScreen: "scrDetailLeave")
                                    })
                                }
                            })
                        }
                    }
                }
            }
        }
        else
        {
            if (!seenArr.contains(currentUser.id))
            {
                if let tabItems = self.tabBarController?.tabBar.items {
                    self.flagNotice = self.flagNotice - 1
                    noticeCount.set(self.flagNotice, forKey: "noticeCount")
                    let tabItem = tabItems[2]
                    tabItem.badgeValue = String(self.flagNotice)
                    
                    if (flagNotice == 0) {
                        tabItem.badgeValue = nil
                    }
                }
                
                let notice:Dictionary<String, Any> = ["userSeen":listNotice[indexPath.row].userSeen + ";" + currentUser.id, "date":listNotice[indexPath.row].day, "time": listNotice[indexPath.row].time, "content":listNotice[indexPath.row].content, "idContent": listNotice[indexPath.row].idContent]
                let tableNameNotice = ref.child("NoticesMore").child(listNotice[indexPath.row].idNotice)
                tableNameNotice.setValue(notice)
                
                listNotice[indexPath.row].userSeen = listNotice[indexPath.row].userSeen + ";" + currentUser.id
            }
            
            let cell:NoticeTableViewCell = tableView.cellForRow(at: indexPath as IndexPath)! as! NoticeTableViewCell
            cell.contentView.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
            cell.lblContent.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
            
            if (listNotice[indexPath.row].content == "học phí")
            {
                let tableName = ref.child("Tuitions")
                tableName.observe(.childAdded) { (snapshot) in
                    let postDict = snapshot.value as? [String:AnyObject]
                    if (postDict != nil) {
                        if (snapshot.key == self.listNotice[indexPath.row].idContent)
                        {
                            let camp:String = (postDict?["camp"])! as! String
                            let date:String = (postDict?["date"])! as! String
                            let extra:String = (postDict?["extra"])! as! String
                            let month:String = (postDict?["month"])! as! String
                            let study:String = (postDict?["study"])! as! String
                            let sum:String = (postDict?["sum"])! as! String
                            let support:String = (postDict?["support"])! as! String
                            let verhical:String = (postDict?["verhical"])! as! String
                            let year:String = (postDict?["year"])! as! String
                            selectedTuition = Tuition(id: snapshot.key, camp: camp, extra: extra, study: study, support: support, verhical: verhical, year: year, month: month, date: date, sum: sum)
                            self.gotoScreenWithBack(idScreen: "scrDetailTuition")
                        }
                    }
                    else {
                        print ("Không có học phí")
                    }
                }
            }
            else
            {
                selectedDayMenu = listNotice[indexPath.row].idContent
                self.gotoScreenWithBack(idScreen: "scrDayOfWeek")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:NoticeTableViewCell = tableView.cellForRow(at: indexPath as IndexPath)! as! NoticeTableViewCell
        cell.contentView.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
        cell.lblContent.backgroundColor = UIColor.init(displayP3Red: CGFloat(255)/255, green: CGFloat(255)/255, blue: CGFloat(255)/255, alpha: 1.0)
        
    }
}
