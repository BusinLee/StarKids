//
//  AddTuitionViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/22/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class AddTuitionViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtStudy: UITextField!
    @IBOutlet weak var txtSupport: UITextField!
    @IBOutlet weak var txtCamp: UITextField!
    @IBOutlet weak var txtVerhical: UITextField!
    @IBOutlet weak var txtExtra: UITextField!
    @IBOutlet weak var lblSum: UILabel!
    
    var stringConvert:Array<String> = Array<String>()
    var text:String = ""
    var sum:Int = 0
    var yearTuition:String = ""
    var monthTuition:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //txtStudy.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        
        txtStudy.delegate = self
        txtSupport.delegate = self
        txtCamp.delegate = self
        txtVerhical.delegate = self
        txtExtra.delegate = self
        lblSum.text = "0"
        let date = Date()
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        if (month <= 4)
        {
            lblTitle.text = "Học phí tháng \(month + 1) năm học \(year - 1)-\(year)"
            yearTuition = "năm học \(year - 1)-\(year)"
        }
        else
        {
            if (month >= 8)
            {
                lblTitle.text = "Học phí tháng \(month + 1) năm học \(year)-\(year + 1)"
                yearTuition = "năm học \(year)-\(year + 1)"
            }
            else
            {
                lblTitle.text = "Học phí tháng \(month + 1) học kì hè \(year)"
                yearTuition = "học kì hè \(year)"
            }
        }
        monthTuition = "tháng \(month + 1)"
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Thêm học phí"
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(btnXong))
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc func btnXong(sender: AnyObject) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let day = formatter.string(from: date)
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        if (self.txtStudy.text == "")
        {
            self.txtStudy.text = "0"
        }
        if (self.txtCamp.text == "")
        {
            self.txtCamp.text = "0"
        }
        if (self.txtSupport.text == "")
        {
            self.txtSupport.text = "0"
        }
        if (self.txtExtra.text == "")
        {
            self.txtExtra.text = "0"
        }
        if (self.txtVerhical.text == "")
        {
            self.txtVerhical.text = "0"
        }
        
        let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn thêm học phí mới?", preferredStyle: .alert)
        let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            let tuition:Dictionary<String,String> = ["date":day, "sum":self.lblSum.text!, "month": self.monthTuition, "year": self.yearTuition, "study": self.txtStudy.text!, "support": self.txtSupport.text!, "verhical": self.txtVerhical.text!, "extra": self.txtExtra.text!, "camp": self.txtCamp.text!]
            let tableName = ref.child("Tuitions").childByAutoId()
            let randomChild = tableName.key
            tableName.setValue(tuition)

            
            let notice:Dictionary<String, Any> = ["userSeen":"", "date":day, "time": "\(hour)"+":"+"\(minute)","idContent": randomChild, "content": "học phí"]
            let tableNameNotice = ref.child("NoticesMore")
            tableNameNotice.childByAutoId().setValue(notice)
            //////////
            let alert1:UIAlertController = UIAlertController(title: "Thông báo", message: "Thêm thành công", preferredStyle: .alert)
            let btnOk1:UIAlertAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                self.gotoScreen(idScreen: "mainTabBarController")
            })
            alert1.addAction(btnOk1)
            self.present(alert1, animated: true, completion: nil)
        }
        alert.addAction(btnOk)
        alert.addAction(btnCancel)
        present(alert, animated: true, completion: nil)
    }
    
}
extension AddTuitionViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        stringConvert.removeAll()
        text = ""
        
        if (textField.tag == 1)
        {
            var sumFlag = textField.text?.replacingOccurrences(of: ".", with: "")
            if (sumFlag == "")
            {
                sumFlag = "0"
            }
            sum = sum - Int(sumFlag!)!
            
            let sumCharacters = Array(String(sum))
            var stringConvertSum:Array<String> = Array<String>()
            var textSum:String = ""
            var flagSum:Int = 0
            for i in stride(from: sumCharacters.count - 1, through: 0, by: -1) {
                flagSum = flagSum + 1
                stringConvertSum.append(String(sumCharacters[i]))
                if (flagSum == 3)
                {
                    flagSum = 0
                    stringConvertSum.append(".")
                }
            }
            for i in stride(from: stringConvertSum.count - 1, through: 0, by: -1) {
                if (i == stringConvertSum.count - 1 && stringConvertSum[i] != ".")
                {
                    textSum = textSum + stringConvertSum[i]
                }
                if (i != stringConvertSum.count - 1)
                {
                    textSum = textSum + stringConvertSum[i]
                }
            }
            self.lblSum.text = textSum + " VNĐ"
        }
        
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let string = textField.text
        let characters = Array(string!)
        
        var flag:Int = 0
        for i in stride(from: characters.count - 1, through: 0, by: -1) {
            flag = flag + 1
            stringConvert.append(String(characters[i]))
            if (flag == 3)
            {
                flag = 0
                stringConvert.append(".")
            }
        }
        for i in stride(from: stringConvert.count - 1, through: 0, by: -1) {
            if (i == stringConvert.count - 1 && stringConvert[i] != ".")
            {
                text = text + stringConvert[i]
            }
            if (i != stringConvert.count - 1)
            {
                text = text + stringConvert[i]
            }
        }
        textField.text = text
        
        if (textField.tag == 1)
        {
            var sumFlag = textField.text?.replacingOccurrences(of: ".", with: "")
            if (sumFlag == "")
            {
                sumFlag = "0"
            }
            sum = sum + Int(sumFlag!)!
            
            let sumCharacters = Array(String(sum))
            var stringConvertSum:Array<String> = Array<String>()
            var textSum:String = ""
            var flagSum:Int = 0
            for i in stride(from: sumCharacters.count - 1, through: 0, by: -1) {
                flagSum = flagSum + 1
                stringConvertSum.append(String(sumCharacters[i]))
                if (flagSum == 3)
                {
                    flagSum = 0
                    stringConvertSum.append(".")
                }
            }
            for i in stride(from: stringConvertSum.count - 1, through: 0, by: -1) {
                if (i == stringConvertSum.count - 1 && stringConvertSum[i] != ".")
                {
                    textSum = textSum + stringConvertSum[i]
                }
                if (i != stringConvertSum.count - 1)
                {
                    textSum = textSum + stringConvertSum[i]
                }
            }
            self.lblSum.text = textSum + " VNĐ"
        }
    }
}
