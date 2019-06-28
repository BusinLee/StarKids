//
//  DetailInfoController.swift
//  StarKids1
//
//  Created by Thanh Lê on 5/4/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//
import Firebase
import UIKit

class DetailInfoController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var txtNickName: UITextField!
    @IBOutlet weak var pickerBirthDay: UIPickerView!
    @IBOutlet weak var txtBirthYear: UITextField!
    @IBOutlet weak var lblFlash: UILabel!
    @IBOutlet weak var pickerClass: UIPickerView!
    @IBOutlet weak var lblTeacherName: UILabel!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var txtFatherName: UITextField!
    @IBOutlet weak var txtFatherPhone: UITextField!
    @IBOutlet weak var txtMotherName: UITextField!
    @IBOutlet weak var txtMotherPhone: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtIllness: UITextField!
    @IBOutlet weak var txtLeaveDay: UITextField!
    @IBOutlet weak var txtEvaluation: UITextField!
    @IBOutlet weak var txtHobby: UITextField!
    @IBOutlet weak var txtAbility: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var lblTeacher: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblFatherName: UILabel!
    @IBOutlet weak var lblFatherPhone: UILabel!
    @IBOutlet weak var lblMotherName: UILabel!
    @IBOutlet weak var lblMotherPhone: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblIllness: UILabel!
    @IBOutlet weak var lblDayLeave: UILabel!
    @IBOutlet weak var lblEvaluation: UILabel!
    @IBOutlet weak var lblHobby: UILabel!
    @IBOutlet weak var lblAbility: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var btnEditBasic: UIButton!
    @IBOutlet weak var btnEditHeath: UIButton!
    @IBOutlet weak var btnEditStudy: UIButton!
    @IBOutlet weak var btnEditMore: UIButton!
    
    var imgData:Data!
    var activeTextField:UITextField!
    var arrDate = [[Int]]()
    var arrClasses:Array<String> = Array<String>()
    var arrTeacherName:Array<String> = Array<String>()
    var day:String = "01"
    var month:String = "01"
    var rightButton:UIBarButtonItem!
    var gender:String = selectedStudent.gender
    var className:String = selectedStudent.className
    var teacherName:String = selectedStudent.teacherName
    var itemAtDefaultPosition: String?
    var defaultRowIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if (currentUser.role == "student")
        {
            btnEditMore.isHidden = true
            btnEditBasic.isHidden = true
            btnEditHeath.isHidden = true
            btnEditStudy.isHidden = true
        }
        setDefaultValueForComponet(user: selectedStudent)
        
        imgData = UIImage(named: "camera")!.pngData()
        imgAvatar.layer.cornerRadius = 0.5 * imgAvatar.bounds.size.width
        imgAvatar.clipsToBounds = true
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.borderColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0).cgColor
        
        btnMale.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnMale.clipsToBounds = true
        
        btnFemale.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnFemale.clipsToBounds = true
        
        btnCancle.layer.cornerRadius = 5
        btnCancle.isHidden = true
        changeColorOfRadioButton(btnYellow: btnMale, btnWhite: btnFemale)
        txtNickName.delegate = self
        txtBirthYear.delegate = self
        txtFatherName.delegate = self
        txtFatherPhone.delegate = self
        txtMotherName.delegate = self
        txtMotherPhone.delegate = self
        txtWeight.delegate = self
        txtHeight.delegate = self
        txtIllness.delegate = self
        txtLeaveDay.delegate = self
        txtEvaluation.delegate = self
        txtHobby.delegate = self
        txtNote.delegate = self
        txtAbility.delegate = self
        pickerBirthDay.delegate = self
        pickerBirthDay.dataSource = self
        pickerClass.delegate = self
        pickerClass.dataSource = self
        
        hideGroupBasicTxt(hide: true)
        hideGroupHeathTxt(hide: true)
        hideGroupStudyTxt(hide: true)
        hideGroupMoreTxt(hide: true)
        
        let tableName = ref.child("Classes")
        tableName.observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String:AnyObject]
            if (postDict != nil)
            {
                let className:String = (postDict?["className"])! as! String
                let teacherName:String = (postDict?["teacherName"])! as! String
                self.arrTeacherName.append(teacherName)
                self.arrClasses.append(className)
                self.pickerClass.reloadAllComponents()
            } else {
                print("Không có class")
            }
            var defaultRowIndex1 = self.arrClasses.index(of: selectedStudent.className)
            if(defaultRowIndex1 == nil) { defaultRowIndex1 = 0 }
            self.pickerClass.selectRow(defaultRowIndex1!, inComponent: 0, animated: false)
        })
        
        var dayP:Int?
        var monthP:Int?
        let daySplit = selectedStudent.birthDay.components(separatedBy: "/")
        let dayInt:Int = Int(daySplit[0])!
        let monthInt:Int = Int(daySplit[1])!
        day = daySplit[0]
        month = daySplit[1]
        print("\(monthInt)")
        for i in 0...1 {
            var row = [Int]()
            for j in 0...30 {
                row.append(j+1)
                if (i==0 && j == (dayInt - 1)) {
                    dayP = j
                }
                if (i==1 && j == (monthInt - 1)) {
                    monthP = j
                }
                if (i==1 && j==11) {
                    break
                }
            }
            arrDate.append(row)
        }
        if (dayP == nil) {dayP = 0}
        if (monthP == nil) {monthP = 0}
        pickerBirthDay.selectRow(dayP!, inComponent: 0, animated: false)
        pickerBirthDay.selectRow(monthP!, inComponent: 1, animated: false)
        
        
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = selectedStudent.fullName
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(btnXong))
        rightButton = (navigationBar?.rightBarButtonItem)!
        self.navigationItem.rightBarButtonItem = nil;
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY =  self.view.frame.size.height - keyboardSize.height
        let editTextY:CGFloat! = (self.activeTextField?.frame.origin.y)! - 500
        if editTextY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editTextY! - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    @objc func btnXong(sender: AnyObject) {
        let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn cập nhật thông tin không?", preferredStyle: .alert)
        let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            let alertActivity:UIAlertController = UIAlertController(title: "", message: "Đang xử lý", preferredStyle: .alert)
            let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
            activity.frame = CGRect(x: self.view.frame.size.width/2-20, y: 60, width: 0, height: 0)
            activity.color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
            alertActivity.view.addSubview(activity)
            activity.startAnimating()
            let height:NSLayoutConstraint = NSLayoutConstraint(item: alertActivity.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.15)
            alertActivity.view.addConstraint(height);
            self.present(alertActivity, animated: true, completion: nil)
            
            if ((self.month == "04" || self.month == "06" || self.month == "09" || self.month == "11") && self.day == "31") {
                //----------self.lbValid.isHidden = false
                alertActivity.dismiss(animated: true, completion: nil)
            } else {
                if (self.month == "02" && (self.day == "30" || self.day == "31")) {
                    //------------self.lbValid.isHidden = false
                    alertActivity.dismiss(animated: true, completion: nil)
                } else {
                    if (self.month == "02" && self.day == "29" && (Int(self.txtBirthYear.text!)! % 4) != 0) {
                        //---------self.lbValid.isHidden = false
                        alertActivity.dismiss(animated: true, completion: nil)
                    } else {
                        let tableName = ref.child("Students")
                        let userId = tableName.child(selectedStudent.id)
                        let user:Dictionary<String,Any> = ["email":selectedStudent.email,"fullName":selectedStudent.fullName,"linkAvatar":selectedStudent.linkAvatar,"nickName":self.txtNickName.text!, "className":self.className, "teacherName":self.teacherName, "birthDay":self.day+"/"+self.month+"/"+self.txtBirthYear.text!, "gender":self.gender, "hobby":self.txtHobby.text!, "fatherName":self.txtFatherName.text!, "fatherPhone":self.txtFatherPhone.text!, "motherName":self.txtMotherName.text!, "motherPhone":self.txtMotherPhone.text!, "illness":self.txtIllness.text!,"evaluation":self.txtEvaluation.text!,"note":self.txtNote.text!,"ability":self.txtAbility.text!,"weight":Int(self.txtWeight.text!),"height":Int(self.txtHeight.text!),"dayLeave":Int(self.txtLeaveDay.text!)]
                        userId.setValue(user)
                        
                        tableName.observe(.childAdded, with: { (snapshot) -> Void in
                            let postDict = snapshot.value as? [String:AnyObject]
                            if (postDict != nil)
                            {
                                if (snapshot.key == selectedStudent.id) {
                                    let email:String = (postDict?["email"])! as! String
                                    let fullName:String = (postDict?["fullName"])! as! String
                                    let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                                    let nickName:String = (postDict?["nickName"])! as! String
                                    let className:String = (postDict?["className"])! as! String
                                    let teacherName:String = (postDict?["teacherName"])! as! String
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
                                    
                                    selectedStudent = Student(id: selectedStudent.id, email: email ?? "nil", fullName: fullName ?? "nil", linkAvatar: linkAvatar ?? "nil", nickName: nickName ?? "nil", className: className ?? "nil", teacherName: teacherName ?? "nil", birthDay: birthDay ?? "nil", gender: gender ?? "nil", hobby: hobby ?? "nil", fatherName: fatherName ?? "nil", fatherPhone: fatherPhone ?? "nil", motherName: motherName ?? "nil", motherPhone: motherPhone ?? "nil", weight: weight ?? 0, height: height ?? 0, illness: illness ?? "nil", dayLeave: dayLeave ?? 0, evaluation: evaluation ?? "nil", note: note ?? "nil", ability: ability ?? "nil")
                                    let url:URL = URL(string: selectedStudent.linkAvatar)!
                                    do
                                    {
                                        let data:Data = try Data(contentsOf: url)
                                        selectedStudent.avatar = UIImage(data: data)
                                    }
                                    catch
                                    {
                                        print("lỗi gán avatar current user")
                                    }
                                }
                            }
                        })
                        
                        self.setDefaultValueForComponet(user: selectedStudent)
                        self.imgAvatar.image = selectedStudent.avatar
                        
                        alertActivity.dismiss(animated: true, completion: {
                            let alert1:UIAlertController = UIAlertController(title: "Thông báo", message: "Cập nhật thành công", preferredStyle: .alert)
                            let btnOk1:UIAlertAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                self.hideGroupBasicLbl(hide: false)
                                self.hideGroupBasicTxt(hide: true)
                                self.hideGroupHeathLbl(hide: false)
                                self.hideGroupHeathTxt(hide: true)
                                self.hideGroupStudyLbl(hide: false)
                                self.hideGroupStudyTxt(hide: true)
                                self.hideGroupMoreLbl(hide: false)
                                self.hideGroupMoreTxt(hide: true)
                                self.btnCancle.isHidden = true
                                self.navigationItem.rightBarButtonItem = nil;
                                self.setDefaultValueForComponet(user: selectedStudent)
                            })
                            alert1.addAction(btnOk1)
                            self.present(alert1, animated: true, completion: nil)
                            
                        })
                    }
                }
            }
        }
        alert.addAction(btnOk)
        alert.addAction(btnCancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btn_Male(_ sender: Any) {
        gender = "Nam"
        changeColorOfRadioButton(btnYellow: btnMale, btnWhite: btnFemale)
    }
    
    @IBAction func btn_Female(_ sender: Any) {
        gender = "Nữ"
        changeColorOfRadioButton(btnYellow: btnFemale, btnWhite: btnMale)
    }
    
    @IBAction func tap_lblMale(_ sender: Any) {
        gender = "Nam"
        changeColorOfRadioButton(btnYellow: btnMale, btnWhite: btnFemale)
    }
    
    @IBAction func tap_lblFemale(_ sender: Any) {
        gender = "Nữ"
        changeColorOfRadioButton(btnYellow: btnFemale, btnWhite: btnMale)
    }
    
    @IBAction func btn_EditBasic(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = rightButton;
        self.btnCancle.isHidden = false
        hideGroupBasicTxt(hide: false)
        hideGroupBasicLbl(hide: true)
        if (selectedStudent.gender == "Nữ") {
            self.changeColorOfRadioButton(btnYellow: btnFemale, btnWhite: btnMale)
        }
    }
    
    @IBAction func btn_EditHeath(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = rightButton;
        self.btnCancle.isHidden = false
        hideGroupHeathTxt(hide: false)
        hideGroupHeathLbl(hide: true)
    }
    
    @IBAction func btn_EditStudy(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = rightButton;
        self.btnCancle.isHidden = false
        hideGroupStudyTxt(hide: false)
        hideGroupStudyLbl(hide: true)
    }
    
    @IBAction func btn_EditMore(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = rightButton;
        self.btnCancle.isHidden = false
        hideGroupMoreTxt(hide: false)
        hideGroupMoreLbl(hide: true)
    }
    
    @IBAction func btn_Cancle(_ sender: Any) {
        let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn huỷ thay đổi không?", preferredStyle: .alert)
        let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            self.navigationItem.rightBarButtonItem = nil;
            self.hideGroupBasicTxt(hide: true)
            self.hideGroupBasicLbl(hide: false)
            self.hideGroupHeathTxt(hide: true)
            self.hideGroupHeathLbl(hide: false)
            self.hideGroupStudyTxt(hide: true)
            self.hideGroupStudyLbl(hide: false)
            self.hideGroupMoreTxt(hide: true)
            self.hideGroupMoreLbl(hide: false)
            self.btnCancle.isHidden = true
        }
        alert.addAction(btnOk)
        alert.addAction(btnCancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btn_Camera(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Thông báo", message: "Chọn", preferredStyle: .alert)
        let btnPhoto:UIAlertAction = UIAlertAction(title: "Photo", style: .default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
        let btnCamera:UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerController.SourceType.camera
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
            return arrDate.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return arrDate[component].count
        } else {
            return arrClasses.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return String(arrDate[component][row])
        } else {
            return String(arrClasses[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
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
        } else {
            className = String(arrClasses[row])
            teacherName = String(arrTeacherName[row])
        }
    }
    
    func setDefaultValueForComponet(user:Student) {
        var dayP:Int?
        var monthP:Int?
        let daySplit = user.birthDay.components(separatedBy: "/")
        let dayInt:Int = Int(daySplit[0])!
        let monthInt:Int = Int(daySplit[1])!
        day = daySplit[0]
        month = daySplit[1]
        if (arrDate.count != 0) {
            for j in 0...30 {
                if (arrDate[0][j] == dayInt) {
                    dayP = j
                    break
                }
            }
            for j in 0...11 {
                if (arrDate[1][j] == monthInt) {
                    monthP = j
                    break
                }
            }
            pickerBirthDay.selectRow(dayP!, inComponent: 0, animated: false)
            pickerBirthDay.selectRow(monthP!, inComponent: 1, animated: false)
        }
        
        if (arrClasses.count != 0) {
            for i in 0...arrClasses.count {
                if (arrClasses[i] == user.className) {
                    className = user.className
                    pickerClass.selectRow(i, inComponent: 0, animated: false)
                    break
                }
            }
        }
        
        txtBirthYear.text = daySplit[2]
        txtNickName.text = user.nickName
        txtFatherName.text = user.fatherName
        txtFatherPhone.text = user.fatherPhone
        txtMotherName.text = user.motherName
        txtMotherPhone.text = user.motherPhone
        txtWeight.text = String(user.weight)
        txtHeight.text = String(user.height)
        txtIllness.text = user.illness
        txtLeaveDay.text = String(user.dayLeave)
        txtEvaluation.text = user.evaluation
        txtHobby.text = user.hobby
        txtAbility.text = user.ability
        txtNote.text = user.note
        
        imgAvatar.image = user.avatar
        lblNickName.text = user.nickName
        lblBirthday.text = user.birthDay
        lblClass.text = user.className
        lblTeacher.text = user.teacherName
        lblGender.text = user.gender
        lblFatherName.text = user.fatherName
        lblFatherPhone.text = user.fatherPhone
        lblMotherName.text = user.motherName
        lblMotherPhone.text = user.motherPhone
        lblWeight.text = String(user.weight)
        lblHeight.text = String(user.height)
        lblIllness.text = user.illness
        lblDayLeave.text = String(user.dayLeave)
        lblEvaluation.text = user.evaluation
        lblHobby.text = user.hobby
        lblAbility.text = user.ability
        lblNote.text = user.note
    }
    
    func hideGroupBasicTxt(hide:Bool) {
        txtNickName.isHidden = hide
        pickerBirthDay.isHidden = hide
        lblFlash.isHidden = hide
        txtBirthYear.isHidden = hide
        pickerClass.isHidden = hide
        lblTeacherName.isHidden = hide
        btnMale.isHidden = hide
        lblMale.isHidden = hide
        btnFemale.isHidden = hide
        lblFemale.isHidden = hide
        txtFatherName.isHidden = hide
        txtFatherPhone.isHidden = hide
        txtMotherName.isHidden = hide
        txtMotherPhone.isHidden = hide
    }
    
    func hideGroupHeathTxt(hide:Bool) {
        txtWeight.isHidden = hide
        txtHeight.isHidden = hide
        txtIllness.isHidden = hide
    }
    
    func hideGroupStudyTxt(hide:Bool) {
        txtLeaveDay.isHidden = hide
        txtEvaluation.isHidden = hide
    }
    
    func hideGroupMoreTxt(hide:Bool) {
        txtHobby.isHidden = hide
        txtAbility.isHidden = hide
        txtNote.isHidden = hide
    }
    
    func hideGroupBasicLbl(hide:Bool) {
        btnEditBasic.isHidden = hide
        lblNickName.isHidden = hide
        lblBirthday.isHidden = hide
        lblClass.isHidden = hide
        lblTeacher.isHidden = hide
        lblGender.isHidden = hide
        lblFatherName.isHidden = hide
        lblFatherPhone.isHidden = hide
        lblMotherName.isHidden = hide
        lblMotherPhone.isHidden = hide
    }
    
    func hideGroupHeathLbl(hide:Bool) {
        btnEditHeath.isHidden = hide
        lblWeight.isHidden = hide
        lblHeight.isHidden = hide
        lblIllness.isHidden = hide
    }
    
    func hideGroupStudyLbl(hide:Bool) {
        btnEditStudy.isHidden = hide
        lblDayLeave.isHidden = hide
        lblEvaluation.isHidden = hide
    }
    
    func hideGroupMoreLbl(hide:Bool) {
        btnEditMore.isHidden = hide
        lblHobby.isHidden = hide
        lblAbility.isHidden = hide
        lblNote.isHidden = hide
    }
    
    func changeColorOfRadioButton (btnYellow:UIButton, btnWhite:UIButton) {
        btnYellow.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnYellow.clipsToBounds = true
        btnYellow.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        
        btnWhite.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnWhite.clipsToBounds = true
        btnWhite.backgroundColor = UIColor.white
        btnWhite.layer.borderWidth = 0.5
        btnWhite.layer.borderColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0).cgColor
    }
}
extension DetailInfoController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            let imgValue = max(image.size.width, image.size.height)
            if (imgValue > 3000) {
                imgData = image.jpegData(compressionQuality: 0.1)
            } else
                if (imgValue > 2000) {
                    imgData = image.jpegData(compressionQuality: 0.3)
                } else {
                    imgData = image.pngData()
            }
            self.imgAvatar.image = UIImage(data:imgData)
        }
        else
            if let image = info[.editedImage] as? UIImage {
                let imgValue = max(image.size.width, image.size.height)
                if (imgValue > 3000) {
                    imgData = image.jpegData(compressionQuality: 0.1)
                } else
                    if (imgValue > 2000) {
                        imgData = image.jpegData(compressionQuality: 0.3)
                    } else {
                        imgData = image.pngData()
                }
                self.imgAvatar.image = UIImage(data:imgData)
        }
        self.dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn thay đổi ảnh đại diện không?", preferredStyle: .alert)
        let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel) { (UIAlertAction) in
            self.imgAvatar.image = selectedStudent.avatar
        }
        let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            let alertActivity:UIAlertController = UIAlertController(title: "", message: "Đang xử lý", preferredStyle: .alert)
            let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
            activity.frame = CGRect(x: self.view.frame.size.width/2-20, y: 60, width: 0, height: 0)
            activity.color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
            alertActivity.view.addSubview(activity)
            activity.startAnimating()
            let height:NSLayoutConstraint = NSLayoutConstraint(item: alertActivity.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.15)
            alertActivity.view.addConstraint(height);
            self.present(alertActivity, animated: true, completion: nil)
            
            let url = selectedStudent.linkAvatar
            let storageRefI = storage.reference(forURL: url!)
            storageRefI.delete { error in
                if let error = error {
                    print(error)
                } else {
                    
                    let avatarRef = storageRef.child("avatars/\(selectedStudent.email!).jpg")
                    let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { metadata, error in
                        guard let metadata = metadata else {
                            print("Lỗi up avatar")
                            alertActivity.dismiss(animated: true, completion: nil)
                            return
                        }
                        let size = metadata.size
                        avatarRef.downloadURL { (url, error) in

                            ref.child("Students/\(currentUser.id!)/linkAvatar").setValue(url!.absoluteString)
                            
                            selectedStudent = Student(id: selectedStudent.id!, email: selectedStudent.email!, fullName: selectedStudent.fullName!, linkAvatar: url!.absoluteString, nickName: selectedStudent.nickName!, className: selectedStudent.className!, teacherName: selectedStudent.teacherName!, birthDay: selectedStudent.birthDay!, gender: selectedStudent.gender!, hobby: selectedStudent.hobby!, fatherName: selectedStudent.fatherName!, fatherPhone: selectedStudent.fatherPhone!, motherName: selectedStudent.motherName!, motherPhone: selectedStudent.motherPhone!, weight: selectedStudent.weight!, height: selectedStudent.height!, illness: selectedStudent.illness!, dayLeave: selectedStudent.dayLeave!, evaluation: selectedStudent.evaluation!, note: selectedStudent.note!, ability: selectedStudent.ability!)
                            
                            let url:URL = URL(string: selectedStudent.linkAvatar)!
                            do
                            {
                                let data:Data = try Data(contentsOf: url)
                                selectedStudent.avatar = UIImage(data: data)
                                alertActivity.dismiss(animated: true, completion: {
                                    let alert1:UIAlertController = UIAlertController(title: "Thông báo", message: "Cập nhật thành công", preferredStyle: .alert)
                                    let btnOk1:UIAlertAction = UIKit.UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    alert1.addAction(btnOk1)
                                    self.present(alert1, animated: true, completion: nil)
                                })
                            }
                            catch
                            {
                                print("lỗi gán avatar current user")
                            }
                            self.setDefaultValueForComponet(user: selectedStudent)
                            self.imgAvatar.image = selectedStudent.avatar
                        }
                    }
                    uploadTask.resume()
                }
            }
        }
        alert.addAction(btnOk)
        alert.addAction(btnCancel)
        present(alert, animated: true, completion: nil)
    }
}
