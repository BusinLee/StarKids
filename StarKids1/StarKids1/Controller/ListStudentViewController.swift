//
//  ListStudentViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/21/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class ListStudentViewController: UIViewController {

    @IBOutlet weak var tblListStudent: UITableView!
    
    var listStudent:Array<User> = Array<User> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblListStudent.dataSource = self
        tblListStudent.delegate = self
        
        let tableName = ref.child("Students")
        tableName.observe(.childAdded) { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil) {
                let classId:String = (postDict?["className"])! as! String
                let fullName:String = (postDict?["fullName"])! as! String
                let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                
                if (classId == selectedClass)
                {
                    let student = User(id: snapshot.key, email: "", fullName: fullName, linkAvatar: linkAvatar, phone: "", role: "student")
                    self.listStudent.append(student)
                    self.tblListStudent.reloadData()
                }
            }
            else {
                print ("Không có lớp học")
            }
        }
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Danh sách học sinh"
        
    }
}

extension ListStudentViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStudent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListStudentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListStudentTableViewCell
        
        cell.imgStudent.loadAvatar(link: listStudent[indexPath.row].linkAvatar)
        cell.lblNameStudent.text = listStudent[indexPath.row].fullName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableName = ref.child("Students")
        tableName.observe(.childAdded, with: { (snapshot) -> Void in
            print("vô trong rồi")
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil)
            {
                if (snapshot.key == self.listStudent[indexPath.row].id) {
                    
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
}
