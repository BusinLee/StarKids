//
//  ClassController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/20/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

var selectedClass:String!
class ClassController: UIViewController {

    @IBOutlet weak var tblClass: UITableView!
    
    var listClass:Array<Class> = Array<Class>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblClass.dataSource = self
        tblClass.delegate = self
        
        let tableName = ref.child("Classes")
        tableName.observe(.childAdded) { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil) {
                let className:String = (postDict?["className"])! as! String
                let teacherName:String = (postDict?["teacherName"])! as! String
                
                let tableNameTeacher = ref.child("Teachers").child(teacherName).child("fullName")
                tableNameTeacher.observe(.value, with: { (snapshot1) in
                    let teacher = (snapshot1.value as? String)!
                    
                    let classs:Class = Class(idClass: snapshot.key, className: className, teacherName: teacher)
                    self.listClass.append(classs)
                    self.tblClass.reloadData()
                })
            }
            else {
                print ("Không có lớp học")
            }
        }
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Lớp học"
        
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
}

extension ClassController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listClass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClassTableViewCell
        cell.lblClassName.text = listClass[indexPath.row].className
        cell.lblTeacherName.text = listClass[indexPath.row].teacherName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClass = listClass[indexPath.row].idClass
        gotoScreenWithBack(idScreen: "scrStudentList")
    }
}
