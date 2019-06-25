//
//  MoreController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase

var selectedStudent:Student!
class MoreController: UIViewController {
    let arrIcon:Array<String> = ["class", "contact","tuition","form","menu","student","teacher","logout"]
    let arrMenu:Array<String> = ["Thêm Lớp học","Liên lạc khác","Học phí","Đơn xin nghỉ học","Thực đơn","Thêm học sinh","Thêm giáo viên","Đăng xuất"]
    
    let arrIconTeacher:Array<String> = ["contact","tuition","form","menu","logout"]
    let arrMenuTeacher:Array<String> = ["Liên lạc khác","Học phí","Đơn xin nghỉ học","Thực đơn","Đăng xuất"]
    
    @IBOutlet weak var tblListMenu: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblListMenu.dataSource = self
        tblListMenu.delegate = self
        tblListMenu.alwaysBounceVertical = false
        
        lblName.text = currentUser.fullName
        imgAvatar.image = currentUser.avatar
        
        if (currentUser.role == "admin") {
            tblListMenu.frame = CGRect(x: 0, y: 173, width: 320, height: 360)
        }
    }
    
    @IBAction func tap_ViewDetailIfo(_ sender: Any) {
        if (currentUser.role == "student")
        {
            let tableName = ref.child("Students")
            tableName.observe(.childAdded, with: { (snapshot) -> Void in
                print("vô trong rồi")
                let postDict = snapshot.value as? [String:AnyObject]
                if (postDict != nil)
                {
                    if (snapshot.key == currentUser.id) {
                        
                        print("Kiểm tra lại tên attributes")
                        let email:String = (postDict?["email"])! as! String
                        let fullName:String = (postDict?["fullName"])! as! String
                        let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                        let nickName:String = (postDict?["nickName"])! as! String
                        let classId:String = (postDict?["className"])! as! String
                        let birthDay:String = (postDict?["birthDay"])! as! String
                        let gender:String = (postDict?["gender"])! as! String
                        let hobby:String = (postDict?["hobby"])! as! String
                        let fatherName:String = (postDict?["fatherName"])! as! String
                        let fatherPhone:String = (postDict?["fatherPhone"])! as! String
                        let motherName:String = (postDict?["motherName"])! as! String
                        let motherPhone:String = (postDict?["motherPhone"])! as! String
                        let weight:Int = (postDict?["weight"])! as! Int
                        let height:Int = (postDict?["height"])! as! Int
                        let illness:String = (postDict?["illness"])! as! String
                        let dayLeave:Int = (postDict?["dayLeave"])! as! Int
                        let evaluation:String = (postDict?["evaluation"])! as! String
                        let note:String = (postDict?["note"])! as! String
                        let ability:String = (postDict?["ability"])! as! String
                        
                        
                        let tableName = ref.child("Classes")
                        tableName.observe(.childAdded) { (snapshot1) in
                            let postDict1 = snapshot1.value as? [String:AnyObject]
                            if (postDict1 != nil) {
                                if (snapshot1.key == classId)
                                {
                                    print("Lấy info class rồi")
                                    let className:String = (postDict1?["className"])! as! String
                                    let teacherId:String = (postDict1?["teacherName"])! as! String
                                    
                                    let tableNameTeacher = ref.child("Teachers").child(teacherId).child("fullName")
                                    tableNameTeacher.observe(.value, with: { (snapshot2) in
                                        let teacher = (snapshot2.value as? String)!
                                        
                                        selectedStudent = Student(id: snapshot.key, email: email, fullName: fullName, linkAvatar: linkAvatar, nickName: nickName, className: className, teacherName: teacher, birthDay: birthDay, gender: gender, hobby: hobby, fatherName: fatherName, fatherPhone: fatherPhone, motherName: motherName, motherPhone: motherPhone, weight: weight, height: height, illness: illness, dayLeave: dayLeave, evaluation: evaluation, note: note, ability: ability)
                                        let url:URL = URL(string: selectedStudent.linkAvatar)!
                                        do
                                        {
                                            let data:Data = try Data(contentsOf: url)
                                            selectedStudent.avatar = UIImage(data: data)
                                            self.gotoScreenWithBack(idScreen: "scrDetailInfo")
                                        }
                                        catch
                                        {
                                            print("lỗi gán avatar current user")
                                        }
                                    })
                                }
                            }
                            else {
                                print ("Không có lớp học")
                            }
                        }
                    }
                }
            })
        }
        else
        {
            if (currentUser.role == "teacher")
            {
                let tableName = ref.child("Classes")
                tableName.observe(.childAdded) { (snapshot1) in
                    let postDict1 = snapshot1.value as? [String:AnyObject]
                    if (postDict1 != nil) {
                        let teacherId:String = (postDict1?["teacherName"])! as! String
                        if (teacherId == currentUser.id) {
                            selectedClass = snapshot1.key
                            self.gotoScreenWithBack(idScreen: "scrStudentList")
                        }
                    }
                    else {
                        print("KHông có lớp")
                    }
                }
            }
            else
            {
                self.gotoScreenWithBack(idScreen: "scrClass")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblListMenu.dataSource = self
        tblListMenu.delegate = self
        tblListMenu.alwaysBounceVertical = false
        
        lblName.text = currentUser.fullName
        imgAvatar.image = currentUser.avatar
    }

}

extension MoreController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentUser.role == "admin") {
            return arrIcon.count
        }
        else {
            return arrIconTeacher.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (currentUser.role == "admin") {
            let cell:ScreenMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenMoreTableViewCell
            cell.imgIcon.image = UIImage(named: arrIcon[indexPath.row])
            cell.lblMenu.text = arrMenu[indexPath.row]
            return cell
        }
        else {
            let cell:ScreenMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenMoreTableViewCell
            cell.imgIcon.image = UIImage(named: arrIconTeacher[indexPath.row])
            cell.lblMenu.text = arrMenuTeacher[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (currentUser.role == "admin") {
            switch indexPath.row {
            case 0:
                self.gotoScreenWithBack(idScreen: "scrAddClass")
                break
            case 1:
                self.gotoScreenWithBack(idScreen: "scrListFriend")
                break
            case 2:
                self.gotoScreenWithBack(idScreen: "scrAddTuition")
                break
            case 3:
                self.gotoScreenWithBack(idScreen: "scrLeaveRequest")
                break
            case 4:
            self.gotoScreenWithBack(idScreen: "scrAddMenu")
                break
            case 5:
                self.gotoScreenWithBack(idScreen: "scrAddStudent")
                break
            case 6:
                self.gotoScreenWithBack(idScreen: "scrAddTeacher")
                break
            default:
                let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn đăng xuất?", preferredStyle: .alert)
                let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
                let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        noticeCount.set(nil, forKey: "noticeCount")
                        self.gotoScreen(idScreen: "scrLogin")
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                }
                alert.addAction(btnOk)
                alert.addAction(btnCancel)
                present(alert, animated: true, completion: nil)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            if (currentUser.role == "teacher")
            {
                switch indexPath.row {
                case 0:
                    self.gotoScreenWithBack(idScreen: "scrListFriend")
                    break
                case 1:
                    self.gotoScreenWithBack(idScreen: "scrTuition")
                    break
                case 2:
                    self.gotoScreenWithBack(idScreen: "scrLeaveRequest")
                    break
                case 3:
                    self.gotoScreenWithBack(idScreen: "scrMenuList")
                    break
                default:
                    let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn đăng xuất?", preferredStyle: .alert)
                    let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
                    let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            noticeCount.set(nil, forKey: "noticeCount")
                            self.gotoScreen(idScreen: "scrLogin")
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    }
                    alert.addAction(btnOk)
                    alert.addAction(btnCancel)
                    present(alert, animated: true, completion: nil)
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
            else
            {
                switch indexPath.row {
                case 0:
                    self.gotoScreenWithBack(idScreen: "scrListFriend")
                    break
                case 1:
                    self.gotoScreenWithBack(idScreen: "scrTuition")
                    break
                case 2:
                    self.gotoScreenWithBack(idScreen: "scrAddLeave")
                    break
                case 3:
                    self.gotoScreenWithBack(idScreen: "scrMenuList")
                    break
                default:
                    let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn đăng xuất?", preferredStyle: .alert)
                    let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
                    let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            noticeCount.set(nil, forKey: "noticeCount")
                            self.gotoScreen(idScreen: "scrLogin")
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    }
                    alert.addAction(btnOk)
                    alert.addAction(btnCancel)
                    present(alert, animated: true, completion: nil)
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}
