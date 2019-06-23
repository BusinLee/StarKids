//
//  LeaveRequestViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

var selectedLeaveRequest:LeaveRequest!

class LeaveRequestViewController: UIViewController {

    @IBOutlet weak var tblLeaveRequest: UITableView!
    
    var listLeave:Array<LeaveRequest> = Array<LeaveRequest>()
    var currentClass:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblLeaveRequest.delegate = self
        tblLeaveRequest.dataSource = self
        
        if (currentUser.role == "admin")
        {
            let tableName = ref.child("LeaveRequests")
            tableName.observe(.childAdded) { (snapshot) in
                let postDict = snapshot.value as? [String:AnyObject]
                if (postDict != nil) {
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
                                
                                let leaveRequest:LeaveRequest = LeaveRequest(id: snapshot.key, currentDay: currentDay, fromDay: fromDay, toDay: toDay, reason: reason, fullName: fullName, parent: parentName, linkAvatar: linkAvatar, className: className)
                                self.listLeave.append(leaveRequest)
                                self.tblLeaveRequest.reloadData()
                            })
                        }
                    })
                }
                else {
                    print ("Không có lớp")
                }
            }
        }
        else
        {
            let tableName1 = ref.child("Classes")
            tableName1.observe(.childAdded) { (snapshot4) in
                let postDict4 = snapshot4.value as? [String:AnyObject]
                if (postDict4 != nil) {
                    let teacherId:String = (postDict4?["teacherName"])! as! String
                    if (teacherId == currentUser.id) {
                        self.currentClass = snapshot4.key
                    }
                }
                else {
                    print("KHông có lớp")
                }
            }
            
            let tableName = ref.child("LeaveRequests")
            tableName.observe(.childAdded) { (snapshot) in
                let postDict = snapshot.value as? [String:AnyObject]
                if (postDict != nil) {
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
                            
                            if (self.currentClass == classId)
                            {
                                let tableNameClass = ref.child("Classes").child(classId).child("className")
                                tableNameClass.observe(.value, with: { (snapshot2) in
                                    className = (snapshot2.value as? String)!
                                    
                                    let leaveRequest:LeaveRequest = LeaveRequest(id: snapshot.key, currentDay: currentDay, fromDay: fromDay, toDay: toDay, reason: reason, fullName: fullName, parent: parentName, linkAvatar: linkAvatar, className: className)
                                    self.listLeave.append(leaveRequest)
                                    self.tblLeaveRequest.reloadData()
                                })
                            }
                        }
                    })
                }
                else {
                    print ("Không có lớp học")
                }
            }
        }
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Đơn xin nghỉ học"
    }

}
extension LeaveRequestViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLeave.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LeaveRequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeaveRequestTableViewCell
        cell.imgStudent.loadAvatar(link: listLeave[indexPath.row].linkAvatar)
        cell.lblStudent.text = listLeave[indexPath.row].fullName
        cell.lblDay.text = listLeave[indexPath.row].currentDay
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLeaveRequest = listLeave[indexPath.row]
        gotoScreenWithBack(idScreen: "scrDetailLeave")
    }
}
