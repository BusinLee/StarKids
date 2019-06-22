//
//  AddClassViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/22/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var txtClass: UITextField!
    @IBOutlet weak var pkTeacher: UIPickerView!
    
    var teacher:Array<User> = Array <User> ()
    var teacherId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pkTeacher.delegate = self
        pkTeacher.dataSource = self
        
        let tableName = ref.child("Teachers")
        tableName.observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil)
            {
                let fullName:String = (postDict?["fullName"])! as! String
                let teacherr:User = User(id: snapshot.key, email: "", fullName: fullName, linkAvatar: "", phone: "", role: "")
                self.teacher.append(teacherr)
                self.pkTeacher.reloadAllComponents()
            } else {
                print("Không có teacherr")
            }
        })
        
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Thêm lớp học"
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(btnXong))
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func btnXong(sender: AnyObject) {
        let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn thêm một lớp mới?", preferredStyle: .alert)
        let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            let classs:Dictionary<String,String> = ["className":self.txtClass.text!, "teacherName":self.teacherId]
            let tableNameComments = ref.child("Classes")
            tableNameComments.childByAutoId().setValue(classs)
            
            //////////
            let alert1:UIAlertController = UIAlertController(title: "Thông báo", message: "Thêm thành công", preferredStyle: .alert)
            let btnOk1:UIAlertAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                self.txtClass.text = ""
            })
            alert1.addAction(btnOk1)
            self.present(alert1, animated: true, completion: nil)
        }
        alert.addAction(btnOk)
        alert.addAction(btnCancel)
        present(alert, animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teacher.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teacher[row].fullName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        teacherId = teacher[row].id
    }
}
