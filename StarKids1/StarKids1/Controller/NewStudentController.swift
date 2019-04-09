//
//  NewStudentController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/7/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class NewStudentController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var txtBirthYear: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var btnAddStudent: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var pickerBirthDay: UIPickerView!
    
    var arrDate = [[Int]]()
    var date:String = ""
    var day:String = "01"
    var month:String = "01"
    //let year = Calendar.current.component(.year, from: Date()) - 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerBirthDay.delegate = self
        pickerBirthDay.dataSource = self
        
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
        txtBirthYear.text = String(Calendar.current.component(.year, from: Date()) - 5)
        btnAddStudent.layer.cornerRadius = 5
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func btn_AddStudent(_ sender: Any) {
        if ((month == "4" || month == "6" || month == "9" || month == "11") && day == "31") {
            print("Invalid")
        } else {
            if (month == "2" && (day == "30" || day == "31")) {
                print("Invalid")
            } else {
                if (month == "2" && day == "29" && (Int(txtBirthYear.text!)! % 4) != 0) {
                    print("Invalid")
                } else {
                    date = day + month + txtBirthYear.text!
                    print("Final \(date)")
                }
            }
        }
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
        
        //var abc:String = String(arrDate[component][row])
        
        if (component == 0) {
            if (arrDate[component][row] < 10) {
                day = "0" + String(arrDate[component][row])
            } else {
                day = String(arrDate[component][row])
            }
        }
        else {
            if (arrDate[component][row] < 10) {
                month = "0" + String(arrDate[component][row])
            } else {
                month = String(arrDate[component][row])
            }
        }
    }
}
