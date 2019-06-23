//
//  AddLeaveRequestViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/22/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class AddLeaveRequestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var btnFather: UIButton!
    @IBOutlet weak var btnMother: UIButton!
    @IBOutlet weak var pkFromDay: UIPickerView!
    @IBOutlet weak var pkToDay: UIPickerView!
    @IBOutlet weak var txtReason: UITextView!
    
    var arrDate = [[Int]]()
    var dateF:String = ""
    var dayF:String = "01"
    var monthF:String = "01"
    var dateT:String = ""
    var dayT:String = "01"
    var monthT:String = "01"
    var yearF:Int = 0
    var yearT:Int = 0
    var parents:String = "ba"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...1 {
            var row = [Int]()
            for j in 0...30 {
                row.append(j+1)
                if (i==1 && j==11) {
                    break
                }
            }
            arrDate.append(row)
        }
        txtReason.text = "Nội dung bài viết..."
        txtReason.textColor = UIColor.lightGray
        txtReason.delegate = self
        
        pkFromDay.delegate = self
        pkFromDay.dataSource = self
        pkToDay.delegate = self
        pkToDay.dataSource = self
        
        txtReason.layer.borderWidth = 1
        txtReason.layer.borderColor = UIColor.darkGray.cgColor
        
        btnFather.layer.cornerRadius = 0.5 * btnFather.bounds.size.width
        btnFather.clipsToBounds = true
        
        btnMother.layer.cornerRadius = 0.5 * btnMother.bounds.size.width
        btnMother.clipsToBounds = true
        
        changeColorOfRadioButton(btnYellow: btnFather, btnWhite: btnMother)
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Nộp đơn xin nghỉ học"
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(btnXong))
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func btnXong(sender: AnyObject) {
        let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn nộp đơn xin nghỉ học?", preferredStyle: .alert)
        let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            if (((self.monthF == "04" || self.monthF == "06" || self.monthF == "09" || self.monthF == "11") && self.dayF == "31") || ((self.monthT == "04" || self.monthT == "06" || self.monthT == "09" || self.monthT == "11") && self.dayT == "31")) {
                //----------self.lbValid.isHidden = false

            } else {
                if ((self.monthF == "02" && (self.dayF == "30" || self.dayF == "31")) || (self.monthT == "02" && (self.dayT == "30" || self.dayT == "31"))) {
                    //------------self.lbValid.isHidden = false

                } else {
                    if ((self.monthF == "02" && self.dayF == "29") || (self.monthT == "02" && self.dayT == "29")) {
                        //---------self.lbValid.isHidden = false

                    } else {
                        if (self.setDate())
                        {
                            let leaveRequest:Dictionary<String,String> = ["parent":self.parents, "studentId": currentUser.id, "fromDay": self.dateF, "toDay": self.dateT, "reason": self.txtReason.text!]
                            let tableNameLeave = ref.child("LeaveRequests")
                            tableNameLeave.childByAutoId().setValue(leaveRequest)
                            let alert1:UIAlertController = UIAlertController(title: "Thông báo", message: "Nộp đơn thành công", preferredStyle: .alert)
                            let btnOk1:UIAlertAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                self.txtReason.text = ""
                            })
                            alert1.addAction(btnOk1)
                            self.present(alert1, animated: true, completion: nil)
                        }
                        else
                        {
                            //////////
                            let alert1:UIAlertController = UIAlertController(title: "Thông báo", message: "Ngày không hợp lệ", preferredStyle: .alert)
                            let btnOk1:UIAlertAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                            })
                            alert1.addAction(btnOk1)
                            self.present(alert1, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        alert.addAction(btnOk)
        alert.addAction(btnCancel)
        present(alert, animated: true, completion: nil)
    }
    
    func setDate() -> Bool {
        let date = Date()
       
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        if (Int(monthF)! > month || (Int(monthF)! == month && Int(dayF)! > day))
        {
            yearF = year
            dateF = "\(dayF)/\(monthF)/\(yearF)"
        }
        else
        {
            yearF = year + 1
            dateF = "\(dayF)/\(monthF)/\(yearF)"
        }
        
        if (Int(monthT)! > month || (Int(monthT)! == month && Int(dayT)! > day))
        {
            yearT = year
            dateT = "\(dayT)/\(monthT)/\(yearT)"
        }
        else
        {
            yearT = year + 1
            dateT = "\(dayT)/\(monthT)/\(yearT)"
        }
        
        if (yearT < yearF || (yearT == yearF && monthT < monthF) || ((yearT == yearF && monthT == monthF && dayT < dayF)))
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    @IBAction func btn_Mother(_ sender: Any) {
        parents = "mẹ"
        changeColorOfRadioButton(btnYellow: btnMother, btnWhite: btnFather)
    }
    
    @IBAction func btn_Father(_ sender: Any) {
        parents = "ba"
        changeColorOfRadioButton(btnYellow: btnFather, btnWhite: btnMother)
    }
    
    @IBAction func tap_lblFather(_ sender: Any) {
        parents = "ba"
        changeColorOfRadioButton(btnYellow: btnFather, btnWhite: btnMother)
    }
    
    @IBAction func tap_lblMother(_ sender: Any) {
        parents = "mẹ"
        changeColorOfRadioButton(btnYellow: btnMother, btnWhite: btnFather)
    }
    
    func changeColorOfRadioButton (btnYellow:UIButton, btnWhite:UIButton) {
        btnYellow.layer.cornerRadius = 0.5 * btnFather.bounds.size.width
        btnYellow.clipsToBounds = true
        btnYellow.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        
        btnWhite.layer.cornerRadius = 0.5 * btnFather.bounds.size.width
        btnWhite.clipsToBounds = true
        btnWhite.backgroundColor = UIColor.white
        btnWhite.layer.borderWidth = 0.5
        btnWhite.layer.borderColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0).cgColor
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return arrDate.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrDate[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(arrDate[component][row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if (component == 0) {
                if (arrDate[component][row] < 10) {
                    dayF = "0" + String(arrDate[component][row])
                } else {
                    dayF = String(arrDate[component][row])
                }
            }
            else {
                if (arrDate[component][row] < 10) {
                    monthF = "0" + String(arrDate[component][row])
                } else {
                    monthF = String(arrDate[component][row])
                }
            }
        } else {
            if (component == 0) {
                if (arrDate[component][row] < 10) {
                    dayT = "0" + String(arrDate[component][row])
                } else {
                    dayT = String(arrDate[component][row])
                }
            }
            else {
                if (arrDate[component][row] < 10) {
                    monthT = "0" + String(arrDate[component][row])
                } else {
                    monthT = String(arrDate[component][row])
                }
            }
        }
    }
}
extension AddLeaveRequestViewController:UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Nội dung bài viết..."
            textView.textColor = UIColor.lightGray
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}
