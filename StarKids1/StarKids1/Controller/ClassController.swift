//
//  ClassController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/20/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class ClassController: UIViewController {

    @IBOutlet weak var tblClass: UITableView!
    
    var listClass:Array<Class> = Array<Class>()
    var alertActivity:UIAlertController = UIAlertController(title: "", message: "Đang xử lý", preferredStyle: .alert)
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
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Thêm", style: .done, target: self, action: #selector(btnAdd))
        
    }
    
    @objc func btnAdd(sender: AnyObject) {
        let lblTitle:UILabel = UILabel(frame: CGRect(x: 20.0, y: 45.0, width: 70.0, height: 30.0))
        lblTitle.text = "Tên lớp"
        alertActivity.view.addSubview(lblTitle)
        
        let txtSave:UITextField = UITextField(frame: CGRect(x: 100.0, y: 45.0, width: 150.0, height: 30.0))
        txtSave.backgroundColor = UIColor.init(displayP3Red: CGFloat(236)/255, green: CGFloat(236)/255, blue: CGFloat(236)/255, alpha: 1.0)
        txtSave.layer.borderColor = UIColor.init(displayP3Red: CGFloat(207)/255, green: CGFloat(207)/255, blue: CGFloat(214)/255, alpha: 1.0).cgColor
        txtSave.layer.borderWidth = 1
        txtSave.layer.cornerRadius = 0.5
        
        alertActivity.view.addSubview(txtSave)
        
        let btnAdd = UIButton(frame: CGRect(x: 20, y: 110, width: 107, height: 39))
        btnAdd.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        btnAdd.setTitle("Thêm", for: .normal)
        btnAdd.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        alertActivity.view.addSubview(btnAdd)
        
        let btnClose = UIButton(frame: CGRect(x: 130, y: 110, width: 107, height: 39))
        btnClose.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        btnClose.setTitle("Đóng", for: .normal)
        btnClose.addTarget(self, action: #selector(buttonActionClose), for: .touchUpInside)
        alertActivity.view.addSubview(btnClose)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertActivity.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.3)
        alertActivity.view.addConstraint(height);
        self.present(alertActivity, animated: true, completion: nil)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
    @objc func buttonActionClose(sender: UIButton!) {
        alertActivity.dismiss(animated: true, completion: nil)
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
        
    }
}
